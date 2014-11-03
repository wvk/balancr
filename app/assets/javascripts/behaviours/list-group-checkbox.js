(function() {
  document.on('dom:loaded', function(event) {
    $$('.list-group-item input[type="checkbox"]').each(function(checkbox) {
      var label = checkbox.up('.list-group-item');
      var toggleCheckboxParentClass = function() {
        if (checkbox.checked) {
          label.addClassName('active');
        } else {
          label.removeClassName('active');
        }
      }
      toggleCheckboxParentClass();
      checkbox.on('change', toggleCheckboxParentClass);
    });
  });
})();
