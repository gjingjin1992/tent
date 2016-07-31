// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

const SitesController = Paloma.controller('Sites');

SitesController.updateLocation = function() {

  const updateFn = function() {
    const country  = $("#site_country").val();
    const county   = $("#site_county").val();
    const town     = $("#site_town").val();
    const city     = $("#site_city").val();
    const address  = $('#site_address1').val();

    if (!!country && !!county && !!town && !!city && !!address) {

      const geocoder = new google.maps.Geocoder();
      const full_address = `${country} ${county} ${city} ${town} ${address}`;

      geocoder.geocode({'address': full_address}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          const latitude  = results[0].geometry.location.lat();
          const longitude = results[0].geometry.location.lng();

          $("#site_latitude").val(latitude);
          $("#site_longitude").val(longitude);
        }
      });
    }
  }

  $('#site_country').on('change', updateFn)
  $('#site_county').on('change', updateFn)
  $('#site_town').on('change', updateFn)
  $('#site_city').on('change', updateFn)
  $('#site_address1').on('change', updateFn)
};

SitesController.marker_map = function(){
  const center = new google.maps.LatLng(
    $("#site_latitude").val(),
    $("#site_longitude").val()
  );

  let map = new google.maps.Map(document.getElementById("map"));
  let marker = null;

  setMarker(center);

  function updateLatAndLon() {
    $("#site_latitude").val(this.position.lat());
    $("#site_longitude").val(this.position.lng());
  };

  function setMarker(location) {
    if (marker) {
      marker.setMap(null);
    }

    marker = new google.maps.Marker({
      map: map,
      position: location,
      draggable: true,
      animation: google.maps.Animation.DROP
    });

    map.panTo(marker.position);
    map.setZoom(10);

    updateLatAndLon.bind(marker)();
    google.maps.event.addListener(marker, 'dragend', updateLatAndLon);
  };
}

SitesController.prototype.new = function(){
  SitesController.updateLocation();
};

SitesController.prototype.create = function(){
  SitesController.updateLocation();
};

SitesController.prototype.edit = function() {
  SitesController.marker_map();
};

SitesController.prototype.update = function() {
  SitesController.marker_map();
};

SitesController.prototype.adjust_location = function(){
  SitesController.marker_map();
};
