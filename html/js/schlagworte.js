console.log("schlagworte juhuuuu")

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