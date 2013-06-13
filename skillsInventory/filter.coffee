fs = require 'fs'
_ = require 'underscore'

listifyQuestionType = (list, id, name, conditionCheck) ->
  for item in list
    question = null
    if conditionCheck(item) then question = _.find item.answers, (item) -> item.question_id is id
    if question? and question.answer?
      question.answer = _.map (question.answer.split ','), (str) -> str.trim().toLowerCase()
    item[name] = question

quantifySkillList = (profiles, questionName) ->
  skillList = []
  for profile in profiles
    if profile[questionName]?
      skillList.push profile[questionName].answer...

  skillCounts = _.reduce skillList.sort(), (counts, skill) ->
    unless counts[skill]? then counts[skill] = 0
    counts[skill]++
    return counts 
  , {}

  skillCounts = _.chain(skillCounts).pairs().sortBy((skillCount) -> -skillCount[1]).value()

  return skillList: skillList, skillCounts: skillCounts

file = fs.readFileSync './Profiles.json', 'utf8'
json = JSON.parse file

profiles = ((
  name: profile.name
  bio: profile.bio
  answers: profile.answers
  mentor: profile.mentor) for profile in json.results)

listifyQuestionType profiles, 4402172, 'mentorQuestion', (profile) -> profile.mentor

listifyQuestionType profiles, 4402182, 'parentQuestion', -> true

mentorSkillsInfo = quantifySkillList profiles, 'mentorQuestion'
kidSkillsInfo = quantifySkillList profiles, 'parentQuestion'

console.dir mentorSkillsInfo
console.dir kidSkillsInfo