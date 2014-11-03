/*
 * replaces bootstrap's jquery-based tabs plugin with an unobtrusive, progressively enhanced prototype-based one.
*/

(function() {
  function initTab(li) {
    li.identify();
    var a    = li.down('a');
    var href = a.readAttribute('href');
    var tab  = tabForLink(a);
    if (tab) {
      tab.hide();

      switch (window.location.hash) {
        case href:
          li.addClassName('active');
        case '':
          if (li.hasClassName('active')) {
            tab.show();
          }
      }

      a.on('click', switchTab);
      a.on('balancr:click', switchTab);
    }
  }

  function tabForLink(a) {
    var href = a.readAttribute('href');
    return tabForURI(href);
  }

  function tabForURI(uri) {
    var namedA = document.body.down('a[name="' + uri.sub('#', '') + '"]');
    if (namedA) {
      return namedA.up('.tab-pane');
    } else if (!uri.include('#')) {
      // ignore tabs with links to other resources
      return null;
    } else {
      // warn about links to missing tab panels
      var msg = 'you forgot to add an <a name="' + tabId + '"></a> to one of your tabs.';
      console.warn(msg);
      return null;
    }
  }

  function switchTab(event) {
    var li  = event.findElement('li');
    var a   = li.down('a');
    var tab = tabForLink(a);

    if (history !== undefined) {
      var href = a.readAttribute('href');
      // avoid jumping to anchor in browsers that support the history API
      history.pushState({tab: {li: li.id, uri: href}}, null, href);
      event.stop();
    }

    displayTab(tab, li);
  }

  function displayTab(tab, li) {
    tab.show();
    tab.adjacent('.tab-pane').invoke('hide');
    li.adjacent('li.active').invoke('removeClassName', 'active');
    li.addClassName('active');
  }

  document.on('dom:loaded', function() {
    window.addEventListener('popstate', function(event) {
      if (event.state && event.state.tab) {
        var tab = tabForURI(event.state.tab.uri);
        var li  = $(event.state.tab.li);
        displayTab(tab, li);
      }
    });

    $$('[role=tablist]').each(function(tablist) {
      tablist.select('li').map(initTab);

      if (tablist.down('li.active') === undefined) {
        var activeTabLink = tablist.down('li a');
        var ev = activeTabLink.fire('balancr:click');
      }
    });
  });
})();
