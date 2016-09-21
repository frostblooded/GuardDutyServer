$(document).ready(function(){
  initialize_new_worker_form();
});

function create_worker_input(worker_name) {
  var $worker = $('<div class="worker input-group form-group"></div>');
  var $worker_input = $('<input class="worker-input form-control" type="text" name="workers[]" value="' + worker_name + '"/>');
  var $worker_remove = $('<span class="input-group-btn">' +
    '<button class="btn btn-danger worker-remove" type=button>'+
      '<span class="glyphicon glyphicon-trash" aria-hidden="true">'+
      '</span>'+
    '</button>'+
  '</span>'); // TODO: Find a way to get this into a template

  $worker_remove.click(function() {
    $(this).parent().remove();
  });

  $worker.append($worker_input);
  $worker.append($worker_remove);
  $('#workers').append($worker);
}

function add_worker() {
  $input = $('#new-worker-input');

  if($input.val().length > 0) {
    create_worker_input($input.val());
    $input.val('');
  }
  else {
    alert(I18n.t("empty_field"));
  }
}

function initialize_new_worker_form() {
  $new_worker_button = $('#new-worker-add');

  $new_worker_button.click(add_worker);
  $('#new-worker-input').keypress(function(e) {
    if(e.which == 13) {
      $new_worker_button.click();
      return false;
    }
  });
}
