// This replaces the jQuery based bootstrap behaviour (not yet tested with nested dropdowns).
//
// The only change required for your bootstrap based dropdown menus to make them "progressively enhanced"
// is to put the following into your CSS:
//
//   .dropdown-menu {
//     display: block;
//  }

(function () {
  'use strict';
  var toggleSelector = '[data-toggle="dropdown"]';
  var menuSelector = 'ul.dropdown-menu';

  function toggleDropdownWithMouse(event) {
    var menu = event.element().next(menuSelector);
    toggleMenu(menu);
    event.stop();
  }

  function toggleMenu(menuElement) {
    if (menuElement.hasClassName('open')) {
      hideMenu(menuElement);
    } else {
      showMenu(menuElement);
    }
  }

  function showMenu(menuElement) {
    new Effect.SlideDown(menuElement, {
      duration: 0.2,
      afterFinish: function(effect){
        effect.element.down('li a').focus();
        menuElement.addClassName('open');
      }
    });
//     menuElement.show();
  }

  function hideMenu(menuElement) {
    if (menuElement.hasClassName('open')) {
      new Effect.SlideUp(menuElement, {
        duration: 0.2,
        afterFinish: function(effect) {
          menuElement.removeClassName('open');
        }
      });
//       menuElement.hide();
    } else {
//       menuElement.hide() // just to be sure it's really closed...
    }
  }

  function clearMenus(e) {
    if (e && e.isRightClick()) return;

    $$('.dropdown-menu.open').each(function (element) {
      hideMenu(element);
    })
  }

  function navigateDropdownWithKey(event) {
    if (![Event.KEY_UP, Event.KEY_DOWN, Event.KEY_ESC].include(event.keyCode)) {
      return;
    }

    var activeSelection = event.findElement('a');
    var menu     = activeSelection.up(menuSelector);
    var toggle   = menu.previous(toggleSelector);
    var elements = menu.select('li:not(.disabled) a');
    var index    = elements.indexOf(activeSelection);

    if (event.keyCode === Event.KEY_UP) {
      if (index === 0) {
        hideMenu(menu);
        toggle.focus();
      } else {
        elements[index - 1].focus();
      }
    } else if (event.keyCode === Event.KEY_DOWN) {
      if (index < elements.length - 1) {
        elements[index + 1].focus();
      }
    } else if (event.keyCode == Event.KEY_ESC) {
      clearMenus();
    }
    event.stop();
  }

  function toggleDropdownWithKey(event) {
    var menu = event.findElement(toggleSelector).next(menuSelector);

    if (event.keyCode == Event.KEY_DOWN || event.keyCode == Event.KEY_SPACE) {
      if (!menu.hasClassName('open')) {
        showMenu(menu);
      }
      event.stop();
    } else if (event.keyCode == Event.KEY_UP) {
      if (event.element().match('ul.dropdown-menu li:first-child a')) {
        hideMenu(menu);
      } else if (event.element().match('button')) {
        // do nothing
      } else {
        event.element().previous('li a').focus();
      }
      event.stop();
    } else if (event.keyCode == Event.KEY_TAB) {
      if (event.element().match(toggleSelector)) {
        hideMenu(menu);
      }
    } else if (event.keyCode == Event.KEY_ESC) {
      clearMenus();
      event.stop();
    } else {
      return;
    }
  }

  function Dropdown(element) {
    element = $(element);
    var menu = element.next(menuSelector);
    menu.hide();

    element.on('click', toggleDropdownWithMouse);
    element.on('keydown', toggleDropdownWithKey);
    menu.on('keydown', 'li a', navigateDropdownWithKey);
    menu.on('click', 'a', function(event){ event.element().fire('balancr:dropdown:selected') });
  }

  function init() {
    $$(toggleSelector).map(Dropdown);
    document.on('click', clearMenus);
    document.on('balancr:dropdown:selected', clearMenus);
  }

  function initPartially(event) {
    event.element().select(toggleSelector).map(Dropdown);
  }

  document.on('dom:loaded', init);
  document.on('balancr:dom:loaded', initPartially)
})();
