// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

const SearchesController = Paloma.controller('Searches');

SearchesController.prototype.index = function(){
  $('.datepicker').datepicker({
    autoclose: true,
    format: 'yyyy-mm-dd',
    startDate: 'd',
    todayHighlight: true
  });

  $('.datepicker.start-date').datepicker("update", 'd');
  $('.datepicker.end-date').datepicker("update", '+7d');

  $('.datepicker.start-date').on('change', function(e) {
    let start = e.target.value;
    $('.datepicker.end-date').datepicker('setStartDate', start);
  })
};
