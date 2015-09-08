Dogs = new Mongo.Collection "dogs"

if Meteor.isClient
  Session.set 'currentTemplate', 'index'
  Session.set 'currentDogId', ""

  Template.body.helpers
    current:->
      Session.get 'currentTemplate'
    user:->
      Meteor.user().emails[0].address
    index:->
      if (Session.get 'currentTemplate') == 'index' then true else false
    new:->
      if (Session.get 'currentTemplate') == 'new' then true else false
    edit:->
      if (Session.get 'currentTemplate') == 'edit' then true else false
    userDetails:->
      Meteor.userId()

  # DOG INDEX
  Template.dogIndex.helpers
    dogs:->
      Dogs.find()


  Template.dogIndex.events
    "click #add-new":->
      Session.set 'currentTemplate','new'
    "click .edit":(event)->
      Session.set "currentDogId", this._id
      Session.set "currentTemplate", "edit"
    "click .delete":->
      if Meteor.user()
        if confirm("Are you sure you want to delete?")
          Dogs.remove this._id
      else
        alert "You must be signed in!"


  #EDIT DOG
  Template.editDog.helpers
    currentDog:->
      id = (Session.get 'currentDogId')

      Dogs.findOne
        _id:id

  Template.editDog.events
    "click .back":->
      Session.set 'currentTemplate', 'index'
    "submit form":(event)->
      event.preventDefault()
      if Meteor.user()
        id = (Session.get 'currentDogId')

        Dogs.update
          _id: id
        ,
          $set:
            name:event.target.name.value
            age: event.target.age.value
            breed: event.target.breed.value

        Session.set 'currentTemplate', 'index'
        false
      else
        Session.set('currentTemplate','index')
        alert "You must be signed in!"
        false

  ###############Add New######################
  Template.addDog.events
    "submit form":(event)->
      if Meteor.user()
        name = event.target.dogname.value
        age = event.target.age.value
        breed = event.target.breed.value

        newDog =
          name:name
          age:age
          breed:breed
          createdAt: new Date()

        Dogs.insert newDog
        Session.set 'currentTemplate', 'index'
        false
      else
        Session.set('currentTemplate','index')
        alert "You must be signed in!"
        false

if Meteor.isServer
  Meteor.startup ->
    # code to run on server at starup
