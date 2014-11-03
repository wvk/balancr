(function() {

  var modalSelector = '[data-behaviour=modal]';

  function showModal(element) {
    document.body.addClassName('modal-open');
    element.addClassName('in');
    var backdrop = new Element('a', {href: '', class: 'modal-backdrop in'});
    element.insert({before: backdrop});
  }

  function hideModal(element) {
    element = element || $$(selector + '.in');
    document.body.removeClassName('modal-open');
    element.removeClassName('in');
    $$('.modal-backdrop').invoke('remove');
  }

  function showModalWithStateChange(event, link, dialog) {
    showModal(dialog);

    if (history !== undefined) {
      history.pushState({modal: {show: dialog.id}}, null, link.readAttribute('href'));
      event.stop();
    }
  }

  function hideModalWithStateChange(event, link, dialog) {
    hideModal(dialog);

    if (history !== undefined) {
      history.pushState({modal: {hide: dialog.id}}, null, link.readAttribute('href'));
      event.stop();
    }
  }

  function ModalDialog(element) {
    element.addClassName('modal');

    element.on('click', 'a[href="#!"]', function(event) {
      if (history !== undefined) {
        history.back();
      } else {
        hideModal();
      }
      event.stop();
    });

    if (element.readAttribute('data-backdrop') !== 'static') {
      element.on('click', function(event) {
        if (event.element().hasClassName('modal')) {
//           event.element().fire('balancr:modal:hide');
          hideModalWithStateChange(event, element, element)
        }
      });
    }

    if (element.readAttribute('data-keyboard') !== 'false') {
      element.on('keydown', function(event) {
        if (event.keyCode === Event.KEY_ESC) {
//           event.element().fire('balancr:modal:hide');
          history.popState();
          event.stop();
        }
      });
    }

    return element;
  }

  function LinkToModal(element, dialog) {
    element.on('click', function(event) {
      showModalWithStateChange(event, element, dialog);
    });

    return element;
  }

  function initPartially(event) {
    var toplevelElement = event.element();
    if (toplevelElement === document) {
      toplevelElement = document.body;
    }
    var modals = toplevelElement.select(modalSelector).map(ModalDialog);

    modals.each(function(modal) {
      var linksToModal = toplevelElement.select('a[href="#' + modal.id + '"]');
      linksToModal.each(function(link){ LinkToModal(link, modal) });
    });
  }

  function init(event) {
    initPartially(event);

    window.addEventListener('popstate', function(event) {
      if (event.state && event.state.modal) {
        if (event.state.modal.open) {
          hideModal($(event.state.modal.show));
        } else if (event.state.modal.close) {
          showModal($(event.state.modal.hide));
        } else {
          // invalid state, ignore for now...
        }
      }
    });
  }

  document.on('dom:loaded', init);
  document.on('balancr:dom:loaded', initPartially);
})();
