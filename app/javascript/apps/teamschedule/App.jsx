import React from 'react';
import axios from 'axios';
import graph from 'graphql.js';
import store from '../../common/store';


import TeamScheduleTable from './TeamScheduleTable';

export default class App extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      organization: store.get(this.selectedOrgKey),
      has_token: null,
      is_refreshing: false,
      is_loading: false,
      schedule: null
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
    if (this.state.organization) {
      this.loadSchedule(this.state.organization.id);
    }
  }

  componentWillUnmount() {
    store.unwatch(this.selectedEvent);
  }

  selectedOrgKey = 'selectedOrganization';

  getTokenInformation() {
    const {
      organization
    } = this.state;

    if (organization === null) {
      return;
    }

    axios.get(`/pco/${organization.id}/has_token`)
      .then((response) => {
        this.setState({ has_token: response.data });
      })
      .catch((error) => {
        console.error(error);
      });
  }

  loadSchedule(organization_id) {
    this.setState({ is_loading: true });
    return axios.get(`/api/teamschedule/v1/${organization_id}/schedule/team`)
      .then(res => this.setState({ schedule: res.data }))
      .catch(err => console.error(err))
      .finally(() => this.setState({ is_loading: false }));
  }

  refreshSchedule(organization) {
    this.setState({ is_refreshing: true });
    return axios.post(`/api/teamschedule/v1/${organization.id}/schedule/refresh`, {})
      .then(() => this.loadSchedule(organization.id))
      .catch(err => console.error(err))
      .finally(() => this.setState({ is_refreshing: false }));
  }

  renderPcoAuthButton() {
    const {
      has_token,
      organization
    } = this.state;

    if (has_token === false) {
      return (
        <div>
          <a className="btn btn-lg btn-primary"
            href={`/pco/${organization.id}/auth?redirect_to=${encodeURIComponent(window.location)}`}
          >
            Connect to Planning Center
          </a>
        </div>
      );
    }
  }

  renderRefreshButton() {
    const {
      has_token,
      organization,
      is_refreshing
    } = this.state;

    if (has_token === true) {
      return (
        <div>
          <button type="button" className="btn btn-primary"
            disabled={is_refreshing}
            onClick={() => this.refreshSchedule(organization)}
          >
            {
              is_refreshing ?
                (<span>
                  <i className="fa fa-spin fa-spinner mr-1"></i>
                  Refreshing...
              </span>)
                :
                (<span>
                  <i className="fa fa-refresh mr-1"></i>
                  Refresh Schedule
              </span>)
            }

          </button>
        </div>
      );
    }
  }

  renderHeader(organization) {
    if (organization == null) {
      return;
    }

    return (
      <h1>
        {organization.name}
        <small className="text-muted ml-3">
          Team Schedule
          </small>
      </h1>
    );
  }

  render() {
    const {
      has_token,
      organization,
      schedule
    } = this.state;

    return (
      <div className="container">
        {this.renderHeader(organization)}

        <div className="mb-4">
        {this.renderPcoAuthButton()}
        {this.renderRefreshButton()}
        </div>

        <TeamScheduleTable schedule={schedule}></TeamScheduleTable>
      </div>
    );
  }
}

