(function() {
    var bookmarkletLinks = document.getElementsByClassName('bookmarklet');
    for (var linkIndex = 0; linkIndex < bookmarkletLinks.length; ++linkIndex) {
        var link = bookmarkletLinks[linkIndex];
        var codeID = link.href.substring(link.href.indexOf('#') + 1);
        var code = document.getElementById(codeID);
        if (code) {
            link.href = 'javascript:' + code.innerText;
        }
    }
})();
