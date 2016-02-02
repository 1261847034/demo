//= require jquery.soulmate

$(document).ready(function() {
    render = function(term, data, type){ return term; };
    select = function(term, data, type){ console.log("Selected " + term); };
    $('#search').soulmate({
        url:            '/sm/search',
        types:          ['tag'],
        renderCallback: render,
        selectCallback: select,
        minQueryLength: 1,
        maxResults:     5
    });
});