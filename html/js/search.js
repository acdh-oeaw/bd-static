const indexName = "brenner";

const typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
  server: {
    apiKey: "6r89B0k9bKnJ5YFmqOfXmmSxMDIubUMj",
    nodes: [
      {
        host: "typesense.acdh-dev.oeaw.ac.at",
        port: "443",
        protocol: "https",
      },
    ],
    cacheSearchResultsForSeconds: 2 * 60,
  },
  additionalSearchParameters: {
    query_by: "full_text",
    sort_by: "sort_id:asc",
  },
});

const DEFAULT_CSS_CLASSES = {
  searchableInput: "form-control form-control-sm m-2 border-light-2",
  searchableSubmit: "d-none",
  searchableReset: "d-none",
  showMore: "btn btn-secondary btn-sm align-content-center",
  list: "list-unstyled",
  count: "badge m-2 badge-secondary",
  label: "d-flex align-items-center",
  checkbox: "m-2",
};

const searchClient = typesenseInstantsearchAdapter.searchClient;
const search = instantsearch({
  indexName: indexName,
  searchClient,
  routing: {
    router: instantsearch.routers.history(),
    stateMapping: instantsearch.stateMappings.simple(),
  },
});

search.addWidgets([
  instantsearch.widgets.searchBox({
    container: "#searchbox",
    autofocus: true,
    cssClasses: {
      form: "form-inline",
      input: "form-control col-md-11",
      submit: "btn",
      reset: "btn",
    },
  }),

  instantsearch.widgets.hits({
    container: "#hits",
    cssClasses: {
      item: "w-100",
    },
    templates: {
      empty: "Keine Treffer für <q>{{ query }}</q>",
      item(hit, { html, components }) {
        return html` <div>
          <div class="fs-3">
            <a href="${hit.id}.html">${hit.title}</a>
          </div>
          <div class="text-end">
            ${hit.person && hit.person.length > 0
              ? hit.person.map(
                  (item) =>
                    html`<a href="${item.id}.html" class="pe-2"
                      ><i class="bi bi-person pe-1"></i>${item.label}</a
                    >`
                )
              : ""}
          </div>

          <p>
            ${hit._snippetResult.full_text.matchedWords.length > 0
              ? components.Snippet({ hit, attribute: "full_text" })
              : ""}
          </p>
        </div>`;
      },
    },
  }),

  instantsearch.widgets.stats({
    container: "#stats-container",
    templates: {
      text: `
          {{#areHitsSorted}}
            {{#hasNoSortedResults}}Kein Treffer{{/hasNoSortedResults}}
            {{#hasOneSortedResults}}1 Treffer{{/hasOneSortedResults}}
            {{#hasManySortedResults}}{{#helpers.formatNumber}}{{nbSortedHits}}{{/helpers.formatNumber}} Treffer {{/hasManySortedResults}}
            aus {{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}}
          {{/areHitsSorted}}
          {{^areHitsSorted}}
            {{#hasNoResults}}Keine Treffer{{/hasNoResults}}
            {{#hasOneResult}}1 Treffer{{/hasOneResult}}
            {{#hasManyResults}}{{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}} Treffer{{/hasManyResults}}
          {{/areHitsSorted}}
          gefunden in {{processingTimeMS}}ms
        `,
    },
  }),

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Jahr",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#r-year ",
    attribute: "year",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Suche nach Jahren",
    cssClasses: DEFAULT_CSS_CLASSES,
    templates: {
      showMoreText(data, { html }) {
        return html`<span
          >${data.isShowingMore ? "Weniger anzeigen" : "Mehr anzeigen"}</span
        >`;
      },
    },
  }),

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Heft",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#r-issue ",
    attribute: "issue",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Suche nach Heften",
    cssClasses: DEFAULT_CSS_CLASSES,
    templates: {
      showMoreText(data, { html }) {
        return html`<span
          >${data.isShowingMore ? "Weniger anzeigen" : "Mehr anzeigen"}</span
        >`;
      },
    },
  }),

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Text",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#r-text ",
    attribute: "text.title",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Suche nach Texten",
    cssClasses: DEFAULT_CSS_CLASSES,
    templates: {
      showMoreText(data, { html }) {
        return html`<span
          >${data.isShowingMore ? "Weniger anzeigen" : "Mehr anzeigen"}</span
        >`;
      },
    },
  }),

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Autor*In",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#r-author ",
    attribute: "author",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Suche nach Autor*Innen",
    cssClasses: DEFAULT_CSS_CLASSES,
    templates: {
      showMoreText(data, { html }) {
        return html`<span
          >${data.isShowingMore ? "Weniger anzeigen" : "Mehr anzeigen"}</span
        >`;
      },
    },
  }),

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Personen",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#r-person ",
    attribute: "person.label",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Suche nach Personen",
    cssClasses: DEFAULT_CSS_CLASSES,
    templates: {
      showMoreText(data, { html }) {
        return html`<span
          >${data.isShowingMore ? "Weniger anzeigen" : "Mehr anzeigen"}</span
        >`;
      },
    },
  }),

  instantsearch.widgets.pagination({
    container: "#pagination",
    padding: 2,
    cssClasses: {
      list: "pagination",
      item: "page-item",
      link: "page-link",
    },
  }),
  instantsearch.widgets.clearRefinements({
    container: "#clear-refinements",
    templates: {
      resetLabel: "Reset",
    },
    cssClasses: {
      button: "btn",
    },
  }),

  instantsearch.widgets.currentRefinements({
    container: "#current-refinements",
    cssClasses: {
      delete: "btn",
      label: "badge",
    },
  }),
]);

search.addWidgets([
  instantsearch.widgets.configure({
    attributesToSnippet: ["full_text"],
  }),
]);

search.start();
