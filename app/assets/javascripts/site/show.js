$(document).ready(initialize_new_worker_form);

function create_worker_input(worker_name) {
  var $worker = $('<div class="worker"></div>');
  var $worker_input = $('<input class="worker-input" type="text" name="workers[]" value="' + worker_name + '"/>');
  var $worker_remove = $('<input class="worker-remove" type="button" value="remove"/>');

  $worker_remove.click(function() {
    $(this).parent().remove();
  });

  $worker.append($worker_input);
  $worker.append($worker_remove);
  $('.workers').append($worker);
}

function add_worker() {
  $input = $('.new-worker-input');

  if($input.val().length > 0) {
    create_worker_input($input.val());
    $input.val('');
  }
  else {
    alert('Field is empty, please enter a worker name first')
  }
}

function initialize_new_worker_form() {
  $new_worker_button = $('.new-worker-add');

  $new_worker_button.click(add_worker);
  $('.new-worker-input').keypress(function(e) {
    if(e.which == 13) {
      $new_worker_button.click();
      return false;
    }
  });
}
