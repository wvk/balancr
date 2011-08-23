// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

document.on('change', '.new_invitation #invitation_invitee_id', function(event, element) {
  var invitee_id = $F(element);
  if (invitee_id == ''){
    var url = '/projects.json'
  } else {
    var url = '/users/' + invitee_id + '/projects.json';
  }
  new Ajax.Request(url, {
    method:     'get',
//     onComplete: function(request) { element.fire('ajax:complete', request); },
    onSuccess:  function(request) { element.fire('ajax:success',  request); },
//     onFailure:  function(request) { element.fire('ajax:failure',  request); }
  });
});

document.on('ajax:success', '.new_invitation #invitation_invitee_id', function(event, element) {
  var select   = $('invitation_project_id');
  var projects = select.readAttribute('data-all-projects').evalJSON(true);
  select.update('<option value="">select project</option>'); // remove all options
  projects.forEach(function(my_project) {
    elem = event.memo.responseJSON.find(function(p){ return p.project.id == my_project.project.id})
    if (Object.isUndefined(elem)) {
      var option = new Element('option', {value: my_project.project.id}).update(my_project.project.name);
      select.insert(option);
    }
  });
});
