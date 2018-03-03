import React from 'react';
import moment from 'moment';

import TeamPersonBadge from './TeamPersonBadge';

function TeamScheduleTable(props) {
  const {
    schedule
  } = props;

  if (schedule == null) {
    return null;
  }

  return (
    <div style={{ overflow: 'auto' }}>
      <table className="table serve-team-table">
        <thead>
          <tr>
            <th>Serve Area</th>
            <th>Team</th>
            <th>Position</th>
            {schedule.schedule_dates.map(date => (<th style={{ whiteSpace: 'nowrap' }} key={date}>{moment(date).format('MMM D')}</th>))}
          </tr>
        </thead>
        <tbody>
          {renderScheduleRows(schedule)}
        </tbody>
      </table>
    </div>
  );
}

/**
 *  
 * @param {*} schedule 
 */
function renderScheduleRows(schedule) {
  const serviceTypeIds = Object.keys(schedule.service_types);
  const serviceTypeRowCells = serviceTypeIds.map(serviceTypeId => {
    const serviceTypeContext = {
      schedule,
      serviceTypeId
    };

    return generateServiceTypeRowCells(serviceTypeContext);
  });

  // Merge all of the service type rows together
  return [].concat.apply([], serviceTypeRowCells);

  //return allRowCells.map(cells => <tr>{cells}</tr>);
}

/**
 * Render the service type and all of the teams
 * @param {*} context 
 */
function generateServiceTypeRowCells(context) {
  const {
    schedule,
    serviceTypeId
  } = context;

  const serviceTeams = schedule.service_type_teams[serviceTypeId];
  const teamRows = serviceTeams.map(teamId => {
    const teamContext = {
      schedule,
      serviceTypeId,
      teamId
    };

    return generateTeamRowCells(teamContext);
  });
  // Merge all of the team rows together
  const serviceTypeRows = [].concat.apply([], teamRows);

  // Add the service type column to the first row
  if(serviceTypeRows.length > 0) {
    const serviceTypeName = schedule.service_types[serviceTypeId];
    const serviceTypeCell = (
      <td className="service-type-name" rowSpan={serviceTypeRows.length}>
        {serviceTypeName}
      </td>);
      

    serviceTypeRows[0] = <tr className="team-first">{[serviceTypeCell, ...serviceTypeRows[0].props.children]}</tr>;
  }

  return serviceTypeRows;
}

/**
 * Render the service team and all of the team positions
 * @param {*} context 
 */
function generateTeamRowCells(context) {
  const {
    schedule,
    serviceTypeId,
    teamId
  } = context;

  const teamPositions = schedule.team_positions[teamId];
  const teamRows = teamPositions.map(position => {
    const teamPositionContext = {
      schedule,
      serviceTypeId,
      teamId,
      position
    };

    return generateTeamPositionRowCells(teamPositionContext);
  });

  // Add the team name column to the first row
  if(teamRows.length > 0) {
    const teamName = schedule.team_names[teamId]
    const serviceTypeCell = (
      <td className="team-name" rowSpan={teamRows.length}>
        {teamName}
      </td>);

    teamRows[0] = <tr className="team-position-first">{[serviceTypeCell, ...teamRows[0].props.children]}</tr>;
  }

  return teamRows;
}

/**
 * Render the current team position and all of the
 * people schedule for the given dates
 * @param {*} context 
 */
function generateTeamPositionRowCells(context) {
  const {
    schedule,
    serviceTypeId,
    teamId,
    position
  } = context;

  // Add cells for each plan date we have
  const dateCells = schedule.schedule_dates.map(date => {
    const dateContext = {
      schedule,
      serviceTypeId,
      teamId,
      position,
      date
    };       

    let people = schedule.records[serviceTypeId][teamId][position][date];
    return (
      <td>
        {people && people.map(person => <TeamPersonBadge person={person}></TeamPersonBadge>) }
      </td>
    );
  });

  const nameCell = (
    <td className="team-position-name">
      {position}
    </td>
  );

  return <tr>{[nameCell, ...dateCells]}</tr>;
}

export default TeamScheduleTable;
