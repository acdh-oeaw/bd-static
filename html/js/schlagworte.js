console.log("schlagworte juhuuuu")

const skosSwitchDiv = document.getElementById('skos-switch');
// if (skosSwitchDiv) {
//     const formCheck = document.createElement('div');
//     formCheck.className = 'form-check form-check-inline';

//     const radio = document.createElement('input');
//     radio.type = 'radio';
//     radio.className = 'form-check-input';
//     radio.name = 'show-concepts';
//     radio.id = 'showConceptsRadio';
//     radio.checked = false;

//     const label = document.createElement('label');
//     label.className = 'form-check-label';
//     label.setAttribute('for', 'showConceptsRadio');
//     label.textContent = 'Show concepts';

//     formCheck.appendChild(radio);
//     formCheck.appendChild(label);
//     skosSwitchDiv.appendChild(formCheck);

//     radio.addEventListener('change', function() {
//         const schlagwortSpans = document.querySelectorAll('span.des-schlagwort[data-schlagwort]');
//         schlagwortSpans.forEach(span => {
//             span.classList.add('highlighted');
//         });
//     });
// }
// radio.addEventListener('change', function() {
//     const schlagwortSpans = document.querySelectorAll('span.des-schlagwort[data-schlagwort]');
//     if (radio.checked) {
//         schlagwortSpans.forEach(span => {
//             span.classList.add('highlighted');
//         });
//     } else {
//         schlagwortSpans.forEach(span => {
//             span.classList.remove('highlighted');
//         });
//     }
// });
document.addEventListener('DOMContentLoaded', function() {
    const elementsWithSchlagwort = document.querySelectorAll('.schlagwort-badge');
    
    elementsWithSchlagwort.forEach(element => {
        element.addEventListener('mouseenter', function() {
            const schlagwortValue = this.getAttribute('id');
            const matchingSpans = Array.from(document.querySelectorAll('span.des-schlagwort[data-schlagwort]'))
                .filter(span => span.getAttribute('data-schlagwort') && span.getAttribute('data-schlagwort').includes(schlagwortValue));

            matchingSpans.forEach(span => {
                span.classList.add('highlighted');
            });
            console.log(matchingSpans)
        });

        element.addEventListener('mouseleave', function() {
            const schlagwortValue = this.getAttribute('id');
            const matchingSpans = Array.from(document.querySelectorAll('span.des-schlagwort[data-schlagwort]'))
                .filter(span => span.getAttribute('data-schlagwort') && span.getAttribute('data-schlagwort').includes(schlagwortValue));

            matchingSpans.forEach(span => {
                span.classList.remove('highlighted');
            });
        });
    });
});