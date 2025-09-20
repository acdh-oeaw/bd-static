const indexName = "baedeker";

const typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
  server: {
    apiKey: "gZafS2wgHlRvy0TSOeCY9TZMmHsAAvzT",
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
    sort_by: "rec_id:asc",
  },
});

const DEFAULT_CSS_CLASSES = {
  searchableInput: "form-control form-control-sm m-2 border-light-2",
  searchableSubmit: "d-none",
  searchableReset: "d-none",
  showMore: "btn btn-secondary btn-sm align-content-center",
  list: "list-unstyled",
  count: "badge m-2 badge-secondary",
  label: "d-flex align-items-center text-capitalize",
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
      empty: "Keine Resultate für <q>{{ query }}</q>",
      item(hit, { html, components }) {
        return html` <div>
          <div class="fs-3"><a href="${hit.rec_id}.html">${hit.title}</a></div>
          <p>
            ${hit._snippetResult.full_text.matchedWords.length > 0
              ? components.Snippet({ hit, attribute: "full_text" })
              : ""}
          </p>
          ${hit.concepts.map(
            (item) =>
              html`<a href="${item.id}.html" class="pe-2"
                ><i class="bi bi-geo-alt pe-1"></i>${item.label}</a
              >`
          )}
        </div>`;
      },
    },
  }),

  instantsearch.widgets.sortBy({
    container: "#sort-by",
    items: [
      { label: "Standard", value: `${indexName}` },
      { label: "ID (aufsteigend)", value: `${indexName}/sort/rec_id:asc` },
      { label: "ID (absteigend)", value: `${indexName}/sort/rec_id:desc` },
    ],
  }),

  instantsearch.widgets.stats({
    container: "#stats-container",
    templates: {
      text: `
          {{#areHitsSorted}}
            {{#hasNoSortedResults}}Keine Treffer{{/hasNoSortedResults}}
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
      header: "Band",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-band ",
    attribute: "band",
    searchable: false,
    limit: 10,
    cssClasses: DEFAULT_CSS_CLASSES,
  }),

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Schlagworte",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-concepts ",
    attribute: "concepts.label",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Suche nach Schlagworten",
    cssClasses: DEFAULT_CSS_CLASSES,
  }),

  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: "Schlagwort-ID",
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-conceptids ",
    attribute: "concepts.id",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    limit: 10,
    searchablePlaceholder: "Suche nach Schlagwort-IDs",
    cssClasses: DEFAULT_CSS_CLASSES,
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
      resetLabel: "Filter zurücksetzen",
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
