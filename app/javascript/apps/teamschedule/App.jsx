import React from 'react';
import axios from 'axios';
import graph from 'graphql.js';
import store from '../../common/store';
import moment from 'moment';
var _ = require('lodash/core');

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

  renderScheduleRows(schedule) {
    let rows = [];

    let reversedScheduleDates = schedule.schedule_dates.slice().reverse();

    let currentRow = [];

    let finalizeRow = () => {
      currentRow.reverse();
      rows.push(<tr>{currentRow}</tr>);
      currentRow = [];
    };

    for (let serviceTypeId of Object.keys(schedule.service_types)) {
      let serviceTypeName = schedule.service_types[serviceTypeId];
      let serviceTypeRowSpan = 0;

      let serviceTeams = schedule.service_type_teams[serviceTypeId];

      serviceTeams.forEach((teamId, teamIdx) => {
        let teamName = schedule.team_names[teamId]

        let teamPositions = schedule.team_positions[teamId];
        serviceTypeRowSpan += teamPositions.length;

        teamPositions.forEach((position, positionIdx) => {
          currentRow = [];

          for (let date of reversedScheduleDates) {
            let people = schedule.records[serviceTypeId][teamId][position][date];
            currentRow.push((
              <td>
                {this.renderPersonCell(people)}
              </td>
            ));
          }

          currentRow.push((
            <td style={{whiteSpace: 'nowrap', fontWeight: 'bold'}}>{position}</td>
          ));

          if (positionIdx < teamPositions.length - 1) {
            finalizeRow();
          }
        }); // teamPositions.forEach...

        currentRow.push((
          <td style={{whiteSpace: 'nowrap', fontWeight: 'bold'}} rowSpan={teamPositions.length}>{teamName}</td>
        ));

        if (teamIdx < serviceTeams.length - 1) {
          finalizeRow();
        }

      }); // serviceTeams.forEach...

      currentRow.push((
        <td style={{whiteSpace: 'nowrap', fontWeight: 'bold'}} rowSpan={serviceTypeRowSpan}>{serviceTypeName}</td>
      ));

      finalizeRow();
    }

    rows.reverse();
    return rows;
  }

  renderPersonCell(people) {
    if (people == null) {
      return;
    }

    return people.map(person => (
      <span className="badge badge-default" style={{whiteSpace: 'nowrap'}}>
        <span className="glyphicon glyphicon-envelope" aria-hidden="true"></span>
        {person.name}
      </span>
    )
    );
  }

  renderTable() {
    const {
      schedule
    } = this.state;

    if (schedule == null) {
      return;
    }

    return (
      <div style={{ overflow: 'auto' }}>
        <table className="table table-hover">
          <thead>
            <tr>
              <th>Serve Area</th>
              <th>Team</th>
              <th>Position</th>
              {schedule.schedule_dates.map(date => (<th style={{ whiteSpace: 'nowrap' }} key={date}>{moment(date).format('MMM D')}</th>))}
            </tr>
          </thead>
          <tbody>
            {this.renderScheduleRows(schedule)}
          </tbody>
        </table>
      </div>
    )
  }

  renderHeader(organization) {
    if (organization != null) {
      return (
        <h1>
          {organization.name}
          <small className="text-muted ml-3">
            Team Schedule
          </small>
        </h1>
      )
    }
  }

  render() {
    const {
      has_token,
      organization
    } = this.state;

    return (
      <div className="container">
        {this.renderHeader(organization)}

        {this.renderPcoAuthButton()}
        {this.renderRefreshButton()}

        {this.renderTable()}
      </div>
    );
  }
}

