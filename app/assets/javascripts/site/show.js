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

function initialize_new_worker_form() {
  $('.new-worker-add').click(function() {
    $input = $('.new-worker-input');
    
    create_worker_input($input.val());
    $input.val('');
  });
}
