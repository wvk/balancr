/* Toggles (shows/hides) help texts when clicked.
 *
 * Elements (e.g. h2, h3,...) annotated with [data-toggle-help-block] will
 * get a button that toggles all elements with class="help-block-hidden" within
 * the same <section>. If the [data-toggle-help-block] element is not a child of
 * a <section>, clicking the button will toggle all hidden help blocks found in <body>.
 */

(function() {
  var toggleSelector    = '[data-toggle-help-block]';
  var helpBlockSelector = '.help-block-hidden';

  function toggleHelpBlock(event) {
    var a = event.element();
    var responsibleForSection = a.up('section') || document.body;
    a.toggleClassName('active');
    responsibleForSection.select('.help-block-hidden').invoke('toggle');
    event.stop();
  }

  function helpBlockToggler(element) {
    var a = new Element('a', {class: 'pull-right btn btn-xs btn-default'});
    element.insert({bottom: a});
    a.update('?');
    a.on('click', toggleHelpBlock);
  }

  function init(event) {
    var toplevelElement = event.element();
    if (toplevelElement === document) {
      toplevelElement = document.body;
    }
    toplevelElement.select(toggleSelector).map(helpBlockToggler);
    toplevelElement.select(helpBlockSelector).invoke('hide');
  }

  document.on('dom:loaded', init);
  document.on('balancr:dom:loaded', init);
})();
