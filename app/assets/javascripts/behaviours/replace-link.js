(function() {
  var selector = '[data-replace-link]';

  function replaceLink(remoteLink) {
    var targetSelector = remoteLink.readAttribute('data-target');
    if (targetSelector) {
      var replaceableContent = $(targetSelector);
    } else {
      var replaceableContent = remoteLink;
    }

    new Ajax.Request(remoteLink.readAttribute('href'), {
      method: 'get',
      evalScripts: true,
      withCredentials: true,
      onCreate: function() {
        remoteLink.hide(); // hide to avoid misleading default message to be shown
      },
      onComplete: function() {
        remoteLink.show(); // imitate "JS disabled" behaviour;
      },
      onSuccess: function(response) {
        if (response.responseText.length > 0) {
          replaceableContent.insert({after: response.responseText});
          var elem = replaceableContent.next();
          replaceableContent.remove();
          var evtSender = function() {
            elem.fire('balancr:dom:loaded');
          }
          evtSender.delay(0.01);
        }
      }
    });
  }

  function init(event) {
    var toplevelElement = event.element();
    if (toplevelElement === document) {
      toplevelElement = document.body;
    }
    toplevelElement.select(selector).map(replaceLink);
  }

  document.on('dom:loaded', init);
  document.on('balancr:dom:loaded', init);
})();
