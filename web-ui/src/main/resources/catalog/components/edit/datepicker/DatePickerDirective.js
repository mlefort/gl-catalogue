(function() {
  goog.provide('gn_date_picker_directive');

  var module = angular.module('gn_date_picker_directive', []);

  /**
   *  Create a widget to handle date composed of
   *  a date input and a time input. It can only be
   *  used to create an ISO date. It hides the
   *  need of choosing from ISO type date or datetime.
   *
   *  It's also useful as html datetime input are not
   *  yet widely supported.
   */
  module.directive('gnDatePicker', ['$http', '$rootScope',
    function($http, $rootScope) {

      return {
        restrict: 'A',
        scope: {
          value: '@gnDatePicker',
          label: '@',
          elementName: '@',
          elementRef: '@',
          id: '@'
        },
        templateUrl: '../../catalog/components/edit/datepicker/partials/' +
            'datepicker.html',
        link: function(scope, element, attrs) {
          // Check if browser support date type or not to
          // HTML date and time input types.
          // If not datetimepicker.js is used (it will not
          // support year or month only mode in this case)
          scope.dateTypeSupported = Modernizr.inputtypes.date;

          // Format date when datetimepicker is used.
          scope.formatFromDatePicker = function(date) {
            var format = 'YYYY-MM-DDTHH:mm:ss';
            var dateTime = moment(date);
            scope.dateInput = dateTime.format(format);
          };

          scope.mode = scope.year = scope.month = scope.time =
              scope.date = scope.dateDropDownInput = '';

          // Default date is empty
          // Compute mode based on date length. The format
          // is always ISO YYYY-MM-DDTHH:mm:ss
          if (!scope.value) {
            scope.value = '';
          } else if (scope.value.length === 4) {
            scope.year = parseInt(scope.value);
            scope.mode = 'year';
          } else if (scope.value.length === 7) {
            scope.month = scope.value;
            scope.mode = 'month';
          } else {
            var isDateTime = scope.value.indexOf('T') !== -1;
            var tokens = scope.value.split('T');
            scope.date = isDateTime ? tokens[0] : scope.value;
            scope.time = isDateTime ? tokens[1] : '';
          }
          if (scope.dateTypeSupported !== true) {
            scope.dateInput = scope.value;
            scope.dateDropDownInput = scope.value;
          }

          scope.setMode = function(mode) {
            scope.mode = mode;
          };


          // Build xml snippet based on input date.
          var buildDate = function() {
            var tag = 'gco:Date';

            if (scope.dateTypeSupported !== true) {
              if (scope.dateInput === undefined) {
                return;
              }
              tag = scope.dateInput.indexOf('T') === -1 ?
                  'gco:Date' : 'gco:DateTime';
              scope.dateTime = scope.dateInput;
            } else if (scope.mode === 'year') {
              scope.dateTime = scope.year;
            } else if (scope.mode === 'month') {
              scope.dateTime = scope.month;
            } else if (scope.time) {
              tag = 'gco:DateTime';
              var time = scope.time;
              // TODO: Set seconds, Timezone ?
              scope.dateTime = scope.date;

              // Add seconds if not set
              if (time.length === 5) {
                time += ':00';
              }
              scope.dateTime += 'T' + time;
            } else {
              scope.dateTime = scope.date;
            }
            scope.xmlSnippet = '<' + tag +
                ' xmlns:gco="http://www.isotc211.org/2005/gco">' +
                scope.dateTime + '</' + tag + '>';
          };

          scope.$watch('date', buildDate);
          scope.$watch('time', buildDate);
          scope.$watch('year', buildDate);
          scope.$watch('month', buildDate);
          scope.$watch('dateInput', buildDate);
          scope.$watch('xmlSnippet', function() {
            if (scope.id) {
              $(scope.id).val(scope.xmlSnippet);
              $(scope.id).change();
            }
          });

          buildDate();
        }
      };
    }]);
})();
