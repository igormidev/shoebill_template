I am creating a saas. The idea is that the user will be able to chat with ai in a chat-view interface in the flutter frontend in order to create a template of pdf.
The user will receive in the end a endpoint where he can make a post request with a payload that matchs a schema and we will receive a pdf as result.

I started implementing this as a python script some weeks ago but now I was thinking better and I will use jinja instead. So you will do this refactor since some places are still refering python scripts and this will not be used anymore... To better understand the current structures read the following files (mandatory):

- @shoebill_template_server/lib/src/services/pdf_controller.dart
- @shoebill_template_server/lib/src/api/pdf_related/pdf_visualize_route.dart
- @shoebill_template_server/lib/src/api/chat_session_related/create_template_essentials_endpoint.dart
- @shoebill_template_server/lib/src/api/chat_session_related/chat_controller.dart
- @shoebill_template_server/lib/src/api/chat_session_related/chat_session_endpoint.dart
- @shoebill_template_server/lib/src/api/pdf_related/entities/pdf_declaration.spy.yaml
- @shoebill_template_server/lib/src/api/pdf_related/entities/pdf_implementation_payload.spy.yaml
- @shoebill_template_server/lib/src/api/pdf_related/entities/pdf_content.spy.yaml
- @shoebill_template_server/lib/src/api/pdf_related/entities/schema_property_extensions.dart (very important)

ONLY AFTER READING THOSE 5 FILES YOU CAN CONTINUE - DO NOT CONTINUE WITHOUT HAVING A DEEP UNDERSTANDING OF HOW THEY CURRENTLY WORK SINCE ALL OF THEM WILL BE REFACTORED.

I will explain the flow I expect to happend and you will implement it fully - but splitting into tasks. The client you will NOT touch yet, lets do only the server part. So I will talk about the client part in the explanation bellow but you can read it just as reference, don't perform tasks on the flutter app yet.

# Target UX that we want to achieve - general structure summary

## Entry point
The hole idea is that the user will receive a post endpoint where we will send a payload, that should be valid to a schema defined, and that

The flow I expect is that when the user enters the app we will see a page that will explain to him what the saas is about and that page will have a CTA so the user can start. In order to convert the biggest amount of users possible, I want the flow to be the most smoth as possible. So, I don't want to ask the user to much things to begin to not overhelm him. What I need basicly is:
- A json input payload to use as example for testing
- A prompt text that the user will describe the general looking of the pdf and page structure (ex: put X information in the first page, Y information in the second page - add a header for all pages etc...)
- A schema that will be used to validate the json
- A title that resumes what the template is so the user can identify his template in the dashboard later
- A description that resumes what the template is about so the user can see a short comprehensive description of his template in the dashboard later
- The language the initial version of the pdf will be based on (the language of the json payload)

But I don't want to ask all of that to my user... I want instead to ask only the payload example and then we will generate with ai the rest. Of course, in the client the user will be able to edit the scheama, edit the prompt the ai suggested and those kind of things... This will create a lower friction barrier to start using the product since less inputs are required in order to start (in fact, only 1 input will be required). This is all already done in @shoebill_template_server/lib/src/api/chat_session_related/create_template_essentials_endpoint.dart - but you can add new fields to be generated if you think is needed after the refactor.

With that done, after the user clicks to continue, the user will go to the chat view session. The chat will be handled by the file @shoebill_template_server/lib/src/api/chat_session_related/chat_session_endpoint.dart . You will do a not of refactor here. The first thing si that we will remove the `PdfDeclaration` and `PdfImplementationPayload` and we will have a new structure to replace them since. Those two classes where created in the start of the project where I didn't defined had well defined in my head what I wanted - now I defined and it is composed by 5 "spy.yaml" models ( read all of them, read each single file in the folder @shoebill_template_server/lib/src/api/chat_session_related/entities/template_current_state/ - they are really small files and are extremly required to do this refactor).

Ther idea will be that the user will talk to ai to create a template that will be a jinja template. Currently the first way that I tried to implement this was with a python script and I planed to execute save this python script as a string and when the user called the "PdfVisualizeRoute" we would run in realtime... We will change this approach. Intead we will save a html and css file that will represent the jinja2 template - so remove all references to python (you can even search for the world "python" to see if you forgot any place).

The `ChatSessionEndpoint` will serve to create and edit existing templates.
The user can discard changes - so the changes done will not be updated if it is a tempalte that already existed and will not save unecessary data to the database of a new tempalte if the user chooses to discard.
If the user saves it will create if does not exist and will update if already exists.

The flow of a template is the following:

## Template flow
To start this, read the 4 new files that will replace `PdfDeclaration` and `PdfImplementationPayload`:
  - shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_version.spy.yaml
  - shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_version_implementation.spy.yaml
  - shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_version_input.spy.yaml
  - shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_scaffold.spy.yaml
  - shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_baseline.spy.yaml

The more core thing is the `ShoebillTemplateScaffold` "spy.yaml" model.
It define the root of everything. Here will have general info about what this template is about so the user can recognize it in his dashboard by title/description. It will be the center part that will handle every version of our template (because users can edit a template and by that it will change with the time).
Now lets go to the version themself; the `ShoebillTemplateVersion` "spy.yaml" model.
This will have all the information about the template version. So it will have the schema that is required to a payload json be submited to create a new template, the html and css of the model in `ShoebillTemplateVersionInput`.
With this template in hands, the user will be able to start to create implementations for it. 
So now the @shoebill_template_server/lib/src/api/pdf_related/pdf_generate_route.dart will need to be implemented and with it the user will basicly send a payload, the language and by that create a new 

# Final guidelines
This prompt is available in a readme file called @prompt.md - attatch it to all claude code instances that you will create so the ai knows the general context that is trying to be achieved (but tell the instance to not do the hole md and focus only on the specific task that you are giving to it, this prompt is only for the intance to have a idea of the big picture that is trying to bee achieved). You at the end can also re-read it as well and make a final judment if everything is okay. 

Also, I want you to decide what Claude Code instance you will create and how you will manage those tasks for those cloud instances. Besides that, I want to list a small set of Claude Code instances that I want you to create, and the other ones (that do tasks) you can decide them by yourself. I will basicly suggest some reviewers instances:
- Create a instance, at the end, to use serverpod mcp and check if every serverpod implementation ( write/read ) operation are right. This claude code instance
- Then, create a claude code instance to analyse the code structure and try to identify code smells like places that could be a interface and those kind of things... magic numbers that could be a const ( @shoebill_template_server/lib/src/core/utils/consts.dart ), variables/function names that could be renamed to better name that explain better what they do and those kind of things - in general, it is a claude code instance to garantee clean code. Tell it to also break big functions into smaller and even split into different files our incapsulate them into other classes if needed. Give extreme emphasis to this instance that it should triple-check if it did not broke any logic/flow since it should only refactor - not modify logic and ask it to review its git changes before commiting to ensure that no logic was modified.
- Create a final claude code instance to review all that was done and give you, main thread, considerations about something that might be wrong or not and you , main thread, will decide if it is relevant or not and if it is you will create one or more claude code instances to do those tasks and fix concerns. This is great because a brand new claude code instance will have no bias from previous things since it will have a brand new context.  Of course, like all the other instances, you will also attach this prompt, that is in @prompt.md, for it to use as reference and this instance should check item by item and enter file by file to check if everything was completed correctly (also you can even give permission for this instance to create other instances as well to investigate every asked task).

By the way: Ensure all claude code instances run with the most capable model; opus 4.5. And ask each one of them to ultrathink since this make them think for longer and do the task with more quality.

# Final cleanup

At the end, you will had deleted 100% the following files that will not be used any more:
- @shoebill_template_server/lib/src/services/pdf_generator_service.dart
- @shoebill_template_server/lib/src/api/pdf_related/entities/pdf_declaration.spy.yaml (will be "replaced" by ShoebillTemplateVersion, ShoebillTemplateVersionInput, ShoebillTemplateBaseline etc... )
- @shoebill_template_server/lib/src/api/pdf_related/entities/pdf_implementation_payload.spy.yaml (will be "replaced" by ShoebillTemplateVersion, ShoebillTemplateVersionInput, ShoebillTemplateBaseline etc... )

At the end of all - I want you to create a readme file in the server folder that explain what this saas is about and where all the main files are ( tag them with @ so a future instance of claude code can better understand )