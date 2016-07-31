const SpatialSearch = React.createClass({

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
    pitch_type:    React.PropTypes.string,
    amenities:     React.PropTypes.array,
    start:         React.PropTypes.string,
    end:           React.PropTypes.string,
    guests:        React.PropTypes.number,
    amenity_types: React.PropTypes.array,
    pitch_types:   React.PropTypes.array,
    page:          React.PropTypes.number,
  },

  getInitialState: function() {
    return {
      bounds: this.props.bounds,
      pitch_type: this.props.pitch_type,
      start:  this.props.start,
      end:    this.props.end,
      guests: this.props.guests,
      sites:  [],
      amenities: this.props.amenities,
    };
  },

  getParams: function() {
    return {
      search: {
        pitch_type: this.state.pitch_type,
        start:  this.state.start,
        end:    this.state.end,
        guests: this.state.guests,
        amenities: this.state.amenities,
        bounds: this.state.bounds
      }
    };
  },

  getUpdatedParams: function(paramName, paramVal) {
    let params = this.getParams()
    params['search'][paramName] = paramVal;
    return params;
  },

  updateParam: function(paramName, paramVal) {
    const self = this;
    $.ajax({
      url: '/search.js',
      data: this.getUpdatedParams(paramName, paramVal),
      dataType: 'json',
      success: function(resp) {
        self.setState({
          [paramName]: paramVal,
          sites: resp.sites,
        })
      },
    }).done(function() {
      history.pushState({}, null, this.url.replace("/search.js", "/search"));
    });
  },

  render: function() {
    return (
      <div className="spatialSearchContainer">
        <div className="row">
          <div className="col-sm-12">
            <SearchFilters
              amenity_types={this.props.amenity_types}
              pitch_types={this.props.pitch_types}
              amenities={this.state.amenities}
              guests={this.state.guests}
              start={this.state.start}
              end={this.state.end}
              pitch_type={this.state.pitch_type}
              updateParam={this.updateParam} />
          </div>
        </div>
        <div className="row sites-container">
          <div className="col-sm-6">
            <SitesSidebar
              sites={this.state.sites}
              page={this.props.page}
              updateParam={this.updateParam} />
          </div>
          <div className="col-sm-6">
            <SiteMap
              sites={this.state.sites}
              updateParam={this.updateParam}
              bounds={this.state.bounds} />
          </div>
        </div>
      </div>
    );
  }
});
