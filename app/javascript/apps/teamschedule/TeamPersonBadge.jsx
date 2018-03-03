import React from 'react';

function TeamPersonBadge(props) {
  const {
    person
  } = props;

  return (
    <span className={`badge ${getStyleClass(person)}`} style={{ whiteSpace: 'nowrap' }}>
      {!person.notification_sent && <i class="fa fa-envelope mr-1"></i>}
      {person.name}
    </span>
  );
}

function getStyleClass(person) {
  switch(person.status) {
    case 'C':
      return 'badge-success';
    case 'D':
      return 'badge-danger';
    default:
      return 'badge-light'
  
  }
  
}

export default TeamPersonBadge;
