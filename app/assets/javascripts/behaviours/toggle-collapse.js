/* Toggles (shows/hides) the element referenced in data-target when clicked. */

(function() {
  var toggleSelector = '[data-toggle=collapse]'

  function collapseToggler(element) {
    var targetSelector = element.readAttribute('data-target');
    if (!targetSelector) {
      console.warn('You forgot to specify the data-target attribute on your ' + toggleSelector + 'element.');
    } else {
      $$(targetSelector).invoke('hide');
      element.on('click', function(event) {
        $$(targetSelector).each(function(e){ Effect.toggle(e, 'slide', {duration: 0.3}) });
        event.stop();
      });
    }
  }

  function init(event) {
    var toplevelElement = event.element();
    if (toplevelElement === document) {
      toplevelElement = document.body;
    }
    toplevelElement.select(toggleSelector).map(collapseToggler);
  }

  document.on('dom:loaded', init);
  document.on('balancr:dom:loaded', init);
})();
