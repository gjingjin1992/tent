var SitesSidebar = React.createClass({

  propTypes: {
    sites: React.PropTypes.array,
    page:  React.PropTypes.number,
  },

  getInitialState: function() {
    return {
      from: 0,
      to: 12,
      sitesPerPage: 12,
    };
  },

  componentDidMount: function() {
    $('#pagination').pagination({
        items: this.props.sites.length,
        itemsOnPage: this.state.sitesPerPage,
        currentPage: this.props.page,
        cssStyle: 'light-theme',
        onPageClick: function(pageNumber, e) {
          this.setState({
            from: (pageNumber - 1) * this.state.sitesPerPage,
            to: pageNumber * this.state.sitesPerPage
          })
        }.bind(this)
    });
  },

  componentWillReceiveProps: function(nextProps) {
    $("#pagination").pagination('updateItems', nextProps.sites.length);
    $("#pagination").pagination('selectPage', 1);
  },

  render: function() {
    return (
      <div className="site-list pre-scrollable">
        <ul>
          {this.props.sites.slice(this.state.from, this.state.to).map(function(site, idx) {
            return (
              <li key={idx} className="site-result">
                <div className="col-md-6">
                  <a href={site.url}>
                    <img className="img-responsive" src={site.image}></img>
                  </a>
                  <div className="row">
                    <div className="col-sm-9">
                      <div>{site.address}</div>
                      <div>{site.town}</div>
                    </div>
                    <div className="col-sm-3">{site.formatted_price}</div>
                  </div>
                </div>
              </li>
            );
          })}
        </ul>
        <div className="clearfix"></div>
        <nav className="col-sm-12" id="pagination"></nav>
      </div>
    );
  }
});
