# -*- coding: utf-8 -*-
class Notifier < ActionMailer::Base
  default :from => "admin@ergolis.com"

  def new_question(user, question)
    @recipient = user
    @question = question
    mail(:to => @recipient.email_sign, :subject => mail_subject("Nouvelle question : "+@question.name))
  end

  def new_answer(user, answer)
    @recipient = user
    @answer = answer
    mail(:to => @recipient.email_sign, :subject => mail_subject("Nouvelle réponse à "+@question.name))
  end
  
  def new_comment(user, comment)
    @recipient = user
    @comment = comment
    mail(:to => @recipient.email_sign, :subject => mail_subject("Nouveau commentaire"))
  end
  
  def new_publication(user, publication)
    @recipient = user
    @publication = publication
    mail(:to => @recipient.email_sign, :subject => mail_subject("Nouvelle publication : "+@publication.name))
  end

  protected

  def mail_subject(title)
    text = ""
    if Parameter.has?("site.name")
      text << "["
      text << Parameter["site.name"]
      text << "] "
    end
    text << title
    return text
  end
  

end
