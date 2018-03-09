import React from 'react';
import graph from 'graphql.js';
import store from '../common/store';

 export default class OrganizationDropDown extends React.Component {

  selectedOrgKey = 'selectedOrganization';

  state = {
    selected: null,
    organizations: []
  } 

  componentDidMount() {
    this.setState({selected: store.get(this.selectedOrgKey)});
    this.selectedEvent = store.watch(this.selectedOrgKey, 
      val => this.setState({selected: val})
    );
    this.fetchOrganizations();
  }

  componentWillUnmount() {
    store.unwatch(this.selectedEvent);
  }

  componentWillReceiveProps(nextProps) {
    this.fetchOrganizations();
  }

  selectOrganization = (e, org) => {
    store.set(this.selectedOrgKey, org);
  }

  fetchOrganizations() {
    graphql = graph(`${this.props.account_url}/graphql`, {
      headers: {
        'Authorization': `Bearer ${this.props.token}`
      }
    });

    graphql(`
      {
        organizations {
          id,
          name
        }
      }
      `)()
      .then(res => {
        this.setState({organizations: res.organizations});
        if(!store.get(this.selectedOrgKey)) {
          store.set(this.selectedOrgKey, res.organizations[0]);
        }
      })
      .catch((error) => {
        console.error(error);
      });
  }

  render() {
    const {
      selected,
      organizations
    } = this.state;
    
    if(this.props.token == null) {
      return null;
    }

    return (
      <li className="nav-item dropdown">
        <a
          className="nav-link dropdown-toggle"
          data-toggle="dropdown"
          aria-haspopup="true"
          aria-expanded="false"
        >
          <i className="fa fa-building-o mr-1"></i>
          { selected == null ? '(No Organization)' : selected.name }
        </a>
        <div className="dropdown-menu" aria-labelledby="dropdown01">
        {
          organizations.map(org => (
          <a
            key={org.id}
            onClick={e => this.selectOrganization(e, org)}
            className='dropdown-item'
          >
            {org.name}
          </a>
          ))
        }
          
        </div>
      </li>
    );
  }
}

 