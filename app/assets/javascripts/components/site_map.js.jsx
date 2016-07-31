var SiteMap = React.createClass({

  propTypes: {
    bounds: React.PropTypes.shape({
      sw: React.PropTypes.shape({
        lng: React.PropTypes.number,
        lat: React.PropTypes.number
      }),
      ne: React.PropTypes.shape({
        lng: React.PropTypes.number,
        lat: React.PropTypes.number
      })
    }),
    sites: React.PropTypes.array,
    updateParam: React.PropTypes.func,
  },

  getInitialState: function() {
    return {
      map: null,
      markers: [],
    };
  },

  componentDidMount: function() {
    let bounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(this.props.bounds.sw.lat, this.props.bounds.sw.lng),
      new google.maps.LatLng(this.props.bounds.ne.lat, this.props.bounds.ne.lng)
    );
    this.state.map = new google.maps.Map(document.getElementById("site-map"));
    fitMapBounds(this.state.map, bounds)

    this.state.map.addListener("idle", function() {
      let gBounds = this.state.map.getBounds();
      let bounds = {
        sw: {
          lng: gBounds.getSouthWest().lng(),
          lat: gBounds.getSouthWest().lat()
        },
        ne: {
          lng: gBounds.getNorthEast().lng(),
          lat: gBounds.getNorthEast().lat()
        }
      }
      this.props.updateParam('bounds', bounds);
    }.bind(this));
  },

  componentWillReceiveProps: function(nextProps) {
    let drawnMarkers = this.state.markers.slice(0);
    let newMarkers   = this.convertSitesToMarkers(nextProps.sites);

    let markersToDraw   = this.markersDiff(newMarkers, drawnMarkers);
    let markersToRemove = this.markersDiff(drawnMarkers, newMarkers);
    let markersToKeep   = this.markersDiff(drawnMarkers, markersToRemove);

    this.removeMarkers(markersToRemove);
    this.plotMarkers(markersToDraw);

    this.setState({
      markers: markersToKeep.concat(markersToDraw)
    });

  },

  convertSitesToMarkers: function(sites) {
    return $.map(sites, function(site) {
      return new MarkerWithLabel({
        site: site,
        icon: {
          path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
          scale: 4,
          strokeColor: "#FF0000",
        },
        labelContent:site.formatted_price,
        labelAnchor: new google.maps.Point(20, 22),
        labelClass: 'marker-label',
        position: new google.maps.LatLng(site.latitude, site.longitude),
      });
    });
  },

  markersDiff: function(setOne, setTwo) {
    // markers that are in the first set but not in second
    let map = {};
    $.each(setTwo, function(idx, m) {
      map[m.site.id + '-' + m.site.price] = true;
    });
    return setOne.filter(function(m) {
      return map[m.site.id + '-' + m.site.price] !== true;
    });
  },

  plotMarkers: function(markers) {
    let self = this;
    $.each(markers, function(idx, marker) {
      marker.setMap(self.state.map);

      let infowindow = new google.maps.InfoWindow({
        content: '<h6>'+ marker.site.name +'</h6>' +
          '<img src="'+ marker.site.image +'" width="100%" height="50%">' +
          '<p>'+ marker.site.description +'</p>' +
          '<p> Price for '+ marker.site.guests +' guests during '+ marker.site.checkin +' - '+ marker.site.checkout +' is '+ marker.site.formatted_price +'</p>' +
          '<p><a href="'+ marker.site.url +'">visit</a></p>',
        maxWidth: 150,
      });


      marker.addListener('click', function() {
        infowindow.open(self.state.map, marker);
      });
    });
  },

  removeMarkers: function(markers) {
    $.each(markers, function(idx, marker) {
      marker.addListener('click');
      marker.setMap(null);
    });
  },

  render: function() {
    return <div id="site-map"></div>;
  }
});
