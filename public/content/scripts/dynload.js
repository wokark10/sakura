/*
 * Dynamic load project
 */
var DynLoad = (function () {
    function DynLoad() {
    }
    // Add the hooks
    DynLoad.init = function () {
        // Add an event listener to the document
        document.addEventListener("click", function (e) {
            // Check if a href attribute is set
            if (e.target['href']) {
                // Prevent the default action
                e.preventDefault();
                // Create a new ajax object
                var loader = new AJAX();
                // Set the url
                loader.setUrl(e.target['href']);
                // Add callbacks
                loader.addCallback(200, function () {
                    var doc = (new DOMParser()).parseFromString(loader.response(), "text/html");
                    history.pushState(null, null, e.target['href']);
                    document.head.innerHTML = doc.head.innerHTML;
                    document.getElementById("content").innerHTML = doc.getElementById("content").innerHTML;
                    var evt = document.createEvent('Event');
                    evt.initEvent('load', false, false);
                    window.dispatchEvent(evt);
                });
                // Send request
                loader.start(HTTPMethods.GET);
            }
        });
    };
    return DynLoad;
})();
