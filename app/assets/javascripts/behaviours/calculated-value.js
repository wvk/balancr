(function() {
  $$('select[data-calculated-value]').each(function(selectBox) {
    var helpText = new Element('div', {class: 'help-block col-sm-offset-3'});
    helpText.insert(inputElement.readAttribute('title'));
    inputElement.up('.form-group').insert({after: helpText});

    var resetter = new Element('div', {class: 'resetter input-group-addon warning', title: 'reset'});
    resetter.insert('<i class="glyphicon glyphicon-refresh"></i>');
    selectBox.insert({before: resetter});

    resetter.on('click', function(event) {
      selectBox.value = selectBox.readAttribute('data-calculated-value');
      selectBox.removeAttribute('title');
      selectBox.removeAttribute('data-calculated-value');
      resetter.remove();
      helpText.remove();
    });
  });
})();
