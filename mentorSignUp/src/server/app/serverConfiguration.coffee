module.exports =
  emailToHostHeaderFormat: (req) -> "#{req.body.firstName} #{req.body.lastName} <#{req.body.email}> just signed up to volunteer with CoderDojo Ponce Springs!\n\n"
  emailToHostSubjectFormat: (req) -> "#{req.body.firstName} #{req.body.lastName} just signed up to volunteer with CoderDojo Ponce Springs!"
  emailFrom: 'coderdojo@versionone.com'
  emailTo: 'coderdojo@versionone.com' 
  emailToVolunteerSubject: 'Confirmation of CoderDojo Ponce Springs sign up received'
  emailToVolunteerTextFormat: (req) -> "#{req.body.firstName} #{req.body.lastName}, thanks for volunteering with CoderDojo Ponce Springs! Please fill out the attached background check authorization form and return it to us by following the instructions within it.\n\nHere is a copy of the information you sent us:\n\n"
  emailToVolunteerHtmlFormat: (req) -> "#{req.body.firstName} #{req.body.lastName}, thanks for volunteering with CoderDojo Ponce Springs! <b>Please fill out the attached background check authorization form and return it to us by following the instructions within it.</b><br/><br/><hr/><br/>Here is a copy of the information you sent us:<br/><br/>"