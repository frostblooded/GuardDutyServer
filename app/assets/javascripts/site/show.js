function create_worker_input(worker_name) {
  $worker = $('<form class="worker"></form>');
  $worker_input = $('<input class="worker-input" type="text" value="' + worker_name + '"/>');
  $worker_remove = $('<input class="worker-remove" type="button" value="remove"/>');

  $worker_remove.click(function() {
    $(this).parent().remove();
  });

  $worker.append($worker_input);
  $worker.append($worker_remove);
  $('.workers').append($worker);
}
