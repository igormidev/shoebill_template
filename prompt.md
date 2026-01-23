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
  - shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_baseline_implementation.spy.yaml
  - shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_version_input.spy.yaml
  - shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_scaffold.spy.yaml
  - shoebill_template_server/lib/src/api/pdf_related/entities/template_entities/shoebill_template_baseline.spy.yaml

The more core thing is the `ShoebillTemplateScaffold` "spy.yaml" model.
It define the root of everything. Here will have general info about what this template is about so the user can recognize it in his dashboard by title/description. It will be the center part that will handle every version of our template (because users can edit a template and by that it will change with the time).
Now lets go to the version themself; the `ShoebillTemplateVersion` "spy.yaml" model.
This will have all the information about the template version. So it will have the schema that is required to a payload json be submited to create a new template, the html and css of the model in `ShoebillTemplateVersionInput`.
With this template in hands, the user will be able to start to create implementations for it. 
So now the @shoebill_template_server/lib/src/api/pdf_related/pdf_generate_route.dart will need to be implemented and with it the user will basicly send a payload (ps: the generate route shoud receive the uuid of the `ShoebillTemplateVersionInput` it is trying to create), the language and by that create a new `ShoebillTemplateBaseline` and a first `ShoebillTemplateBaselineImplementation`. So the user will have that route to create a baseline pdf that is nothing more then the implementation of the pdf. When ever the user calls the route to visualize the pdf - the @shoebill_template_server/lib/src/api/pdf_related/pdf_visualize_route.dart - that will receive the uuid of the `ShoebillTemplateBaseline` it will search for the item and get the correct language ( the visualize route will also need to be refactored so all the instances of `PdfDeclaration` are replaced by `ShoebillTemplateBaseline` and the instances of `PdfImplementationPayload` are replaced for `ShoebillTemplateBaselineImplementation` ). The visualize button will get the version for the more apropriate language and if it does not exist it will create that version by seeing the original version of the pdf and translating texts that need translation ( The thing is, we will give the possibility for our user to translate to multiple languages the same pdf. The hardcoded strings of the pdf will be already pre-translated in the html and css schema, but the payload strings will be translated in real time, with a really fast ai, to the target language and then we will create that implementation so we don't need to translate it again ). 

You might be asking youself: "Why we need the class `ShoebillTemplateVersion`? why do we need to have a lot of versions sinced we can just update one version?"
Well, the logic I pretend to do is: If the user changes/edits his template (example: ask to change the background color) I will NOT create a new template version in this case since this does not change the structure of the template and only changes the ui. This way; a pdf generated with a payload in the past for that version will continue to work and when the user makes a request to the "visualize" route to see the pdf he will see the updated version of the ui (since the pdf in rendered in real time and we don't cache it as a blob). So this is very cool since the user can make a edit in the ui and when we opens a link of a pdf he generated in the past, for that same `ShoebillTemplateVersion`, it will still receive the updates of the ui. But theres a catch: We can only do this if the user changes the SCHEMA so then we will yes need to generate a new version. So you should have a logic with a boolean of "didChangedSchema" in the `ChatSessionEndpoint` and when the user changes the schema then when deploying (finishing a session) we won't edit the html/css of the current `ShoebillTemplateVersion` and we will instead create a brand new entity of `ShoebillTemplateVersion` that will be attatched to `ShoebillTemplateScaffold.versions` as the newest version. This is because since the schema changed, there is probably new things that will be sent now (maybe a new field, a new image url) - so the previous `ShoebillTemplateVersion` did not had those variables and because of that if old route tries to build a html/css with a variable that is now missing it will break completly - so thats why if there is a change in ui we can just update the current version but if there is a change in the schema we need to generate a new version of the `ShoebillTemplateVersion` and we will not update the html/css of the version that now will be "old" (not the newest).
By the way, the `ChatSessionEndpoint.sendMessage` should have a optional parameter called newSchema. If this is not null it means the client wants to change the schema for that current session. And with this we will toggle a boolean in someplace to indicate that session had a schema change (so in the `ChatSessionEndpoint.deploySession` we can then enter a flow to create a new version instead of updating the current existing one). With a new version I will notify at the end, when the user deploys, that the uuid had changed. By the way, not only a new schema but also a new example payload as well (stringified since we can't send Map with serverpod endpoints). So maybe you can create a new ".spy.yaml" model called "NewSchemaChangePayload" that will have a SchemaDefinition and a stringified payload example. This will also be attatched to the prompt so the ai was a better context, like: "I am changing the schema from this model to this model - a example of a json that will come in this new payload is Y" so the ai will have a better understanding of what is happening.
Also, the server should check with `SchemaDefinition.validateJsonFollowsSchemaStructure` the stringified payload just to check if the frontend did not sent a broken thing... This json should be set as the `NewTemplateState.referenceStringifiedPayloadJson` as well and the schema as well. By the way add 2 string variables "htmlContent" and "cssContent" to the `DeployReadyTemplateState` implementation so it can be later mapped to `ShoebillTemplateVersionInput` fields when creating/updating the template version.
The client side will be done later. Don't touch nothing related to the client side (flutter app) - this will be done later. In fact it should not be only 

## sendMessage response
Currently the sendMessage response is a 

## Prompt/chat to claude code instance

Now lets go to the part where the user is chating. We will do a TOTAL refactor in the current prompt that is today and in the response as well. Well, the first thing that you should do is guarantee that we will use the approach of Jinja2. The function that currently returns a Python script should return a CSS and an HTML file, the stringified version of those files.

Another thing that you should do is enhance the prompt because currently we are not taking in fact a lot of things, for instance, we don't send to the prompt schema. This is very important. You should send this current schema so the claude code instance in daytona has a clear idea of what is the variables that could be used. More then that, you should tell it to NOT HAVE ANY HARDCODED STRINGS created. All of them should have a logic to make a "switch case" approach of the target language. Yes - thats what I plan to do. I want the pdf to have support for multiple languages, all the languages in `SupportedLanguages` enum at file @shoebill_template_server/lib/src/entities/others/supported_languages.spy.yaml . For the claude code instance that will do this task you should give orientation for it to check the @shoebill_template_server/lib/src/api/pdf_related/pdf_visualize_route.dart since this will give the context so the instance will understand that we translate the payload parts that should be translated and, to mantain consistency, all hardcoded parts of the texts should be translated as well.

Another task you should do in @shoebill_template_server/lib/src/api/pdf_related/pdf_visualize_route.dart is make that all translations will happend in parralel ( make the logic that it identify all strings that need translation - the ones with `SchemaPropertyString.shouldTranslate` as true - and do the translations with ai at the same time with `Future.wait` so they run in parallel ). Create a claude code instance to do this task.

Please garantee that you will tell to the claude code instances that will work on this tasks that are related to the change the prompt that will be sent to claude code instance to use the web research tool. You should tell for it that it's mandatory that they seek for the most updated documentation of Jinja2, and more than that, they should also check for the most updated documentation of Daytona. You should be very explicit for them about how this is mandatory, and that they should not continue to do anything, they should not write any line of code before taking a deep dive in both documentations so they won't write code that is outdated, a previous version of those api's. So they should always be looking to the most up-to-date documentation. This is very important because your default training data could be outdated.

About the font part: Say for the ai to use the default font as "Noto Sans CJK" 

The prompt of claude code will vary depending on some conditions but there are basicly 3 structures:

### Prompt for creating a template
A prompt for when the user is creating the css and html for the first time (the template did not exist yet and the user is explaning how it should be - probably it will be the same suggested prompt of @shoebill_template_server/lib/src/api/chat_session_related/create_template_essentials_endpoint.dart )
This prompt will have no HTML or CSS attatched to it since the user is creating now...
What we will attatch is:
- The json payload example as json (.json file)
- The schema payload as json (.json file)
- A readme file that represents the prompt of the user (user_specification_prompt.md)

### Prompt for editing the template
If the template already exists then the initial prompt will be something like:
- The current state of html file (.html file)
- The current state of the css file (css file)
- The json payload example as json (.json file)
- The schema payload as json (.json file)
- A readme file that represents the prompt of the user (user_specification_prompt.md)

### Change the schema
If the template already exists then the initial prompt will be something like:
- The current state of html file (.html file)
- The current state of the css file (css file)
- The json payload example as json (.json file)
- The schema payload as it currently is (current_schema.json file)
- The schema payloadas how it should be (new_target_schema.json file)
- A readme file that represents the prompt of the user (user_specification_prompt.md)

#### FOR ALL PROMPTS ABOVE:

You should upload both files to the daytona sandbox and in the prompt to claude code you will make reference to both (you can use "@" to tag the files, this is how claude code expect to see the tagged files). So you will build a prompt that explains that the instance task is to create a jinja2 compatible template and you will explain to the claude code that the user had send a description of what he wants and that the claude code should see the readme. Also, tell for the ai in the prompt for in the end create a new claude code instance to review the html and css file and see if it is fully ok with the prompt of the user in the md file - base yourself in this prompt that in the final part I ask you to create a instance to review - write similar. Remember to update the html/css files when doing the follow up messages... Manage all of this gracefully.

Some parts will be common to all prompts - for those parts, you can create hardcoded strings that will be used in 2 or more so this way we won't repeat text ( DRY - dont repeat yourself )

## Prompt verification
This will complement the section above.
In a `ChatMessage` you can see that there are 3 actors
    - The user: the client that is using the saas and sending messages
    - The ai: here we will trait it as the claude code instance running in daytona
    - The system: Any hardcoded response or even review of ai other ai

When the daytona endpoints ends, you should send a new messages with something like (don't follow the content string strict, I typed it as example):
```message
ChatMessage(
  role: ChatActor.system,
  content: "Great. the AI had ended is modification... Now I will verify if there is any error or if there is something missing",
  style: ChatUIStyle.normal,
)
```
Ps: the previous message before this is one with `ChatUIStyle.success` of the `ChatActor.ai` - so now we add a follow up message of the ai saying that it will verify. I want to create a chat dynamic between 3 people where the user asks something, the ai (daytona claude code) is the executor that does what the user asked for and the system (that under the hood will also be a other AI) will review that and provide feedback so we continue to iterate until everything is perfect and the user will be able to view the interaction between that "executor" and "reviewer" (we will lock the textfield in the ui so the user can't send other messages until the reviewer agrees that the goal/intent of the message of the user has achieved).

I want that, when ever the claude code instance ends, we will then use the `IOpenAiService.streamPromptGenerationWithSchemaResponse` of @shoebill_template_server/lib/src/services/ai_services.dart to validate the html and css that the claude code produced. We will use a scheam because we will use a bolean for a variable that will determine if the review was positive or negative and need changes. More then that, the schema will also have the message of AI. This AI will see if the claude code AI had completed with successs the task. It will return a prompt and a bolean that indicates if the task was done or not. Also add a third string that will be the text for the user, something like: "I will ask the instance to fix X, Y and Z that is not aligned with A, B and C that you asked for. Also the ai forgot to implement X that is mandatory for the pdf to work as expected".

Also, before doing the AI part the code could run the mixin that tests the HTML and CSS to see if it works in the first place and if it does not you can call the claude code instance right away notifying that it is not working and the error message.

This should work in a loop - the ai can do at max 6 fix attempts... if after 6 tries it does not work it will stream to the user a message with error text explaining that it did not work...

This reviewer AI will have a very big and complext prompt so it has the max context as possible. DO NOT MAKE THE PROMPT SMALL. Also, you should have 3 types of prompt the same way - one for when creating, other from when editing only ui and one when editing the schema. The review prompts will be very well writen so you can say "The schema was X and the new schema is not Y - see if the new implementation did not let anything pass" and you can put the HTML and CSS texts. You will not send files with `IOpenAiService` - just attatch as plain text in the prompt - there is no problem if the prompt stays giant. For the review, use "google/gemini-3-flash-preview" with max think mode. You should continue to use open router of course.

## Daytona claude code session 
Daytona charges me for time that a session is opened. So after claude code returned a answer I want you to stop to then return with claude code id. Ask the instance to web research claude code documentation to see how session id works.

So the basic way to “stop spending” is:
    1. Stop/exit the sandbox session
    2. Delete the sandbox

So the pattern would be:
    1. Save the Claude session ID (from the SDK).
    2. Stop the Daytona sandbox (delete it, or shut it down).
    3. Later, create a new sandbox (when the user sent the next message)
    4. Start Claude in the new sandbox, and resume using the saved session ID.

This way memory will be preserved but we won't spend money for time that the user is not using the chat...

Use haiku 4.5 for the claude code instance that is running in daytona

The response of daytona should be a string that represents the html file, a string that represents the css file and also the ai text that it returns in the end that is a summary of what was done. By the way, lets change the response of `ChatControllerImpl.sendMessage` and `ChatSessionEndpoint.sendMessage`. It will not be a `ChatMessage` anymore. It will be a abstract "spy.yaml" class named "SendMessageStreamResponseItem" and it will have two implementations; one will be a class that will have as only atribute a `ChatMessage` (so we can continue to have the same behavior we have today) and the other will be a class with the only variable as the `TemplateCurrentState` so we can return to the client how is the current state after all modifications done by daytona instance because we will later display the pdf in the ui ( by the way, create a endpoint that receives a html, css and final ai message and returns a Uint8List that is the pdf - this could use a mixin so it has the same exact logic of the visualize route that also generates ).

Also, when doing the task you should stream the thinking process to the client by chat messages...
`ChatMessage.style` should be `ChatUIStyle.thinkingChunk`

## Other considerations for @shoebill_template_server/lib/src/api/pdf_related/pdf_visualize_route.dart
This part will suffer a general refactor in the sense that it will stop using the Python script and it will start using the Jinja2 framework. So, it will read the HTML and CSS file instead of the Python file that it currently reads, and it will generate with the Python script the Jinja2 file.

Remember that the language will allways be sent to the payload so the template can do the validation if everything is right.

## Jinja rendering
A thing: The jinja 2 rendering logic can be a mixin. The reason for this is that the logic that will render the PDF and return the data blob variable will be used in two places:
1. It will be used first in the visualize route because when the user tries to visualize the PDF, it will create that PDF with that function.
2. It will also be used in the session part because we want to return to the client always the most updated version of the PDF after the client sends it a stream message to create or change something. 

# Final guidelines
This prompt is available in a readme file called @prompt.md - attatch it to all claude code instances that you will create so the ai knows the general context that is trying to be achieved (but tell the instance to not do the hole md and focus only on the specific task that you are giving to it, this prompt is only for the intance to have a idea of the big picture that is trying to bee achieved). You at the end can also re-read it as well and make a final judment if everything is okay. 

Also, I want you to decide what Claude Code instance you will create and how you will manage those tasks for those cloud instances. Besides that, I want to list a small set of Claude Code instances that I want you to create, and the other ones (that do tasks) you can decide them by yourself. I will basicly suggest some reviewers instances:
- Create a instance, at the end, to use serverpod mcp and check if every serverpod implementation ( write/read ) operation are right. This claude code instance
- Each instance should commit at the end if it is doing a task that changes code (not a explorer instance - if you create "explorer" instances you dont need to commit because there is nothing to be commited)
- Then, create a claude code instance to analyse the code structure and try to identify code smells like places that could be a interface and those kind of things... magic numbers that could be a const ( @shoebill_template_server/lib/src/core/utils/consts.dart ), variables/function names that could be renamed to better name that explain better what they do and those kind of things - in general, it is a claude code instance to garantee clean code. Tell it to also break big functions into smaller and even split into different files our incapsulate them into other classes if needed. Give extreme emphasis to this instance that it should triple-check if it did not broke any logic/flow since it should only refactor - not modify logic and ask it to review its git changes before commiting to ensure that no logic was modified.
- Create a final claude code instance to review all that was done and give you, main thread, considerations about something that might be wrong or not and you , main thread, will decide if it is relevant or not and if it is you will create one or more claude code instances to do those tasks and fix concerns. This is great because a brand new claude code instance will have no bias from previous things since it will have a brand new context.  Of course, like all the other instances, you will also attach this prompt, that is in @prompt.md, for it to use as reference and this instance should check item by item and enter file by file to check if everything was completed correctly (also you can even give permission for this instance to create other instances as well to investigate every asked task). That claude cod einstance should look to the original prompt and ask itself: "He request X, and asked to garantee that Y is happening and to delete Z - so I should create one claude code instance just to see if X was done, one claude code instance to see if in fact Y is happening as expected and one claude code instance to see if Z was in fact deleted" - it should create a LOT of instances to garantee that everything wrote in the prompt was achieved. (like, no problem if it will do 30+ explores instances). Remember that you should run this exhaustively until every single criteria of the prompt is matches - the flow is:
1. You run a Claude Code instance to make the general reviews. It can be one or more instances to check one or more things.
2. After it ends, you will see what makes sense and what doesn't make sense.
3. For what makes sense, you should perform a fix through another Claude Code instance.
4. After you did all the fixes, you will then run again to see if anything is missing.
5. So, after all the fixes are done, you will run again just to ensure that after all the fixes, there is still nothing pending.
This way, we will be sure that the prompt was completely satisfied.

By the way: Ensure all claude code instances run with the most capable model; opus 4.5. And ask each one of them to ultrathink since this make them think for longer and do the task with more quality.

# Final cleanup

At the end, you will had deleted 100% the following files that will not be used any more:
- @shoebill_template_server/lib/src/services/pdf_generator_service.dart
- @shoebill_template_server/lib/src/api/pdf_related/entities/pdf_declaration.spy.yaml (will be "replaced" by ShoebillTemplateVersion, ShoebillTemplateVersionInput, ShoebillTemplateBaseline etc... )
- @shoebill_template_server/lib/src/api/pdf_related/entities/pdf_implementation_payload.spy.yaml (will be "replaced" by ShoebillTemplateVersion, ShoebillTemplateVersionInput, ShoebillTemplateBaseline etc... )

At the end of all - I want you to create a readme file in the server folder that explain what this saas is about and where all the main files are ( tag them with @ so a future instance of claude code can better understand )