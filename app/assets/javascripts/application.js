//= require prototype
//= require prototype_ujs
//= require effects
//= require controls
//= require sprintf
//= require_tree ./calendar_date_select
//= require behaviours/all

// patch ajax request in order to allow withCredentials request option (for use with CORS)
Ajax.Request.prototype.request = Ajax.Request.prototype.request.wrap(function(sup, url) {
  if (this.options.withCredentials) {
    this.transport.withCredentials = true;
  }
  sup(url);
});
