(function() {

  goog.provide('gn_related_directive');
  goog.require('gn_relatedresources_service');

  var module = angular.module('gn_related_directive', [
    'gn_relatedresources_service'
  ]);

  /**
   * Shows a list of related records given an uuid with the actions defined in
   * config.js
   */
  module
      .directive(
          'gnRelated',
          [
        '$http',
        'gnGlobalSettings',
        'gnRelatedResources',
        function($http, gnGlobalSettings, gnRelatedResources) {
          return {
            restrict: 'A',
            templateUrl: function(elem, attrs) {
              return attrs.template ||
                      '../../catalog/components/metadataactions/partials/related.html';
            },
            scope: {
              md: '=gnRelated',
              template: '@',
              types: '@',
              title: '@',
              list: '@'
            },
            link: function(scope, element, attrs, controller) {
              scope.updateRelations = function() {
                if (scope.md) {
                  scope.uuid = scope.md.getUuid();
                }
                scope.relations = [];
                if (scope.uuid) {
                  $http.get(
                     'md.relations?_content_type=json&uuid=' +
                     scope.uuid + (scope.types ? '&type=' +
                     scope.types : ''), {cache: true})
                            .success(function(data, status, headers, config) {
                       if (data && data != 'null' && data.relation) {
                         if (!angular.isArray(data.relation)) {
                           scope.relations = [
                             data.relation
                           ];
                         } else {
                           var wfs_relation = {};
                           for (var i = 0; i < data.relation.length; i++) {
                             scope.relations.push(data.relation[i]);
                             // si la ressource est du WFS, on la met de côté pour la suite
                             if (data.relation[i].protocol == 'OGC:WFS') {
                               wfs_relation = JSON.parse(JSON.stringify(data.relation[i]));
                             }
                           }
                         }
                       }
                       // Si une ressource WFS a été trouvé, on crée dynamiquement 3 nouvelles relations (uniquement pour les fiches du catalogue GrandLyon)
                       if (scope.md.source == '233d066a-3045-481f-850a-038e3afc4a44' && wfs_relation && wfs_relation.name) {
                          wfs_relation.protocol = 'LINK';
                          
                          var kmlLink = JSON.parse(JSON.stringify(wfs_relation));
                          kmlLink.url = kmlLink.url.replace('wfs','kml') + '?request=list&typename=' + kmlLink.name;
                          kmlLink.abstract = kmlLink.abstract.replace('(OGC:WFS)',' au format KML');
                          
                          var geojsonLink = JSON.parse(JSON.stringify(wfs_relation));
                          geojsonLink.url = geojsonLink.url + '?SERVICE=WFS&VERSION=2.0.0&outputformat=GEOJSON&maxfeatures=30&request=GetFeature&typename=' + geojsonLink.name;
                          geojsonLink.abstract = geojsonLink.abstract.replace('(OGC:WFS)',' au format GeoJSON');
                          
                          var shapezipLink = JSON.parse(JSON.stringify(wfs_relation));
                          shapezipLink.url = shapezipLink.url + '?SERVICE=WFS&VERSION=2.0.0&outputformat=SHAPEZIP&request=GetFeature&SRSNAME=EPSG:3946&typename=' + shapezipLink.name;
                          shapezipLink.abstract = shapezipLink.abstract.replace('(OGC:WFS)',' au format Shape-ZIP');
                          
                          scope.relations.push(kmlLink,geojsonLink,shapezipLink);
                       }
                     });
                }
              };

              scope.getTitle = function(link) {
                return link.title['#text'] || link.title;
              };

              scope.hasAction = function(mainType) {
                // Do not display add to map action when map
                // viewer is disabled.
                if (mainType === 'WMS' &&
                   gnGlobalSettings.isMapViewerEnabled === false) {
                  return false;
                }
                return angular.isFunction(
                   gnRelatedResources.map[mainType].action);
              };
              scope.config = gnRelatedResources;

              scope.$watchCollection('md', function() {
                scope.updateRelations();
              });

              /**
               * Return an array of all relations of the given types
               * @return {Array}
               */
              scope.getByTypes = function() {
                var res = [];
                var types = Array.prototype.splice.call(arguments, 0);
                angular.forEach(scope.relations, function(rel) {
                  if (types.indexOf(rel['@type']) >= 0) {
                    res.push(rel);
                  }
                });
                return res;
              };
            }
          };
        }]);

  module.directive('relatedTooltip', function() {
    return function(scope, element, attrs) {
      for (var i = 0; i < element.length; i++) {
        element[i].title = scope.$parent.md['@type'];
      }
      element.tooltip();
    };
  });

})();
