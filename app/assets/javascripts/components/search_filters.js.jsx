var SearchFilters = React.createClass({

  propTypes: {
    pitch_type: React.PropTypes.string,
    amenity_types: React.PropTypes.array,
    amenities: React.PropTypes.array,
    start:  React.PropTypes.string,
    end:    React.PropTypes.string,
    guests: React.PropTypes.number,
    pitch_types: React.PropTypes.array,
    updateParam: React.PropTypes.func
  },

  componentDidMount: function() {
    $('.datepicker').datepicker({
      autoclose: true,
      format: 'yyyy-mm-dd',
      startDate: 'd',
      todayHighlight: true
    });

    $('#checkin').datepicker("update",  this.props.start);
    $('#checkout').datepicker("update", this.props.end);

    $('#checkin').on('change', function(e) {
      this.props.updateParam('start', e.currentTarget.value)
    }.bind(this));

    $('#checkout').on('change', function(e) {
      this.props.updateParam('end', e.currentTarget.value)
    }.bind(this));
  },

  guests: function() {
    guests_arr = [];
    for(let i = 1; i < 11; i++) {
      guests_arr.push(
        <option value={i} key={i}>{i}</option>
      );
    }
    return guests_arr;
  },

  handleTypeChange: function(e) {
    this.props.updateParam('pitch_type', e.currentTarget.value)
  },

  handleGuestChange: function(e) {
    this.props.updateParam('guests', parseInt(e.currentTarget.value))
  },

  handleAmenityChange: function(e) {
    let checked = $.map($('.amenityCheckbox:checked'), function(elem) { return elem.value });
    this.props.updateParam('amenities', checked)
  },

  render: function() {
    return (
      <div className="container filters">
        <div className="row">
          <div className="form-group">
            <label className="col-sm-1" for="type">Type</label>
            <div className="col-sm-2">
              <select className="c-select"
                defaultValue={this.props.pitch_type}
                onChange={this.handleTypeChange}>
                <option value="">Any type</option>
                {this.props.pitch_types.map(function(type, idx) {
                  return <option value={type.name} key={idx}>{type.name}</option>
                })}
              </select>
            </div>
          </div>
          <div className="form-group">
            <label className="col-sm-1" for="checkin">Checkin</label>
            <div className="col-sm-2">
              <input type="text" className="datepicker form-control" id="checkin" />
            </div>
          </div>
          <div className="form-group">
            <label className="col-sm-1" for="checkout">Checkout</label>
            <div className="col-sm-2">
              <input type="text" className="datepicker form-control" id="checkout" />
            </div>
          </div>
          <div className="form-group">
            <label className="col-sm-1" for="guests">Guests</label>
            <div className="col-sm-2">
              <select className="c-select" defaultValue={this.props.guests} onChange={this.handleGuestChange}>
                {this.guests()}
              </select>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-sm-1">
            <label>Amenities</label>
          </div>
          <div className="col-sm-10">
            <div className="contol-group">
              {this.props.amenity_types.map(function(amenity, idx) {
                return(
                  <label className="checkbox-inline" key={idx}>
                    <input
                      type="checkbox"
                      className="amenityCheckbox"
                      checked={$.inArray(amenity.name, this.props.amenities) > -1}
                      value={amenity.name}
                      onChange={this.handleAmenityChange}/>{amenity.name}
                  </label>
                );
              }.bind(this))}
            </div>
          </div>
        </div>
      </div>
    );
  }
});
