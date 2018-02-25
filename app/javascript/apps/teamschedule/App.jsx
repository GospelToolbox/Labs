import React from 'react';
import axios from 'axios';
import graph from 'graphql.js';
import store from '../../common/store';

export default class App extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      organization: store.get(this.selectedOrgKey),
      has_token: null
    };

    this.selectedEvent = store.watch(this.selectedOrgKey,
      val => {
        this.setState({ organization: val });
        this.getTokenInformation();
      }
    );
  }

  componentDidMount() {
    this.getTokenInformation();
  }

  componentWillUnmount() {
    store.unwatch(this.selectedEvent);
  }

  selectedOrgKey = 'selectedOrganization';

  getTokenInformation() {
    const {
      organization
    } = this.state;

    console.log(organization);

    if (organization === null) {
      return;
    }

    axios.get(`/pco/has_token?organization_id=${organization.id}`)
      .then((response) => {
        this.setState({ has_token: response.data });
      })
      .catch((error) => {
        console.error(error);
      });
  }

  renderPcoAuthButton(organization) {
    return (
      <div>
        <a className="btn btn-lg btn-primary"
            href={`/pco/auth?organization_id=${organization.id}&redirect_to=${encodeURIComponent(window.location)}`}
        >
          Connect to Planning Center
          </a>
      </div>
    );
  }

  render() {
    const {
      has_token,
      organization
    } = this.state;

    return (
      <div className="container">
        <h1>Team Schedule</h1>
        {organization ? <h2>For {organization.name}</h2> : ''}

        {has_token === false ? this.renderPcoAuthButton(organization) : null}
      </div>
    );
  }
}

