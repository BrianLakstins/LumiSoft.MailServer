

/********** Create stored procedure return types ****************/


CREATE TYPE acl_entry AS (
  "user"      VARCHAR(100),
  permissions VARCHAR(100)
);



CREATE TYPE messageinfo_entry AS (
  "messageid"    VARCHAR(100),
  "size"         INTEGER,
  "date"         TIMESTAMP,
  "messageflags" INTEGER,
  "uid"          BIGINT
);



CREATE TYPE messageitem_entry AS (
  "toplines"     BYTEA,
  "imapenvelope" BYTEA,
  "imapbody"     BYTEA
);



CREATE TYPE recyclebinmessageinfo AS (
  "messageid"    VARCHAR(100),
  "deletetime"   TIMESTAMP,
  "user"         VARCHAR,
  "folder"       VARCHAR,
  "size"         BIGINT,
  "envelope"     VARCHAR
);


/********* Create tables ************************************/


/* Contains mail server domains.
    DomainID    - Domain ID, GUID value is suggested.
    DomainName  - Domain name.
    Description - Domain description.
*/
Create table lsDomains(
        DomainID    varchar(100) UNIQUE Default '',
        DomainName  varchar(100) UNIQUE Default '',
        Description varchar(100)        Default ''
);



/* Contains mail server email addresses.
    LocalPart - Email localpart. localpart[@domain]
    DomainID  - Email domain ID.
    OwnerID   - Email address owner ID.
*/
Create table lsEmailAddresses(
        LocalPart varchar(100) Default '',
        DomainID  varchar(100) Default '',
        OwnerID   varchar(100) Default ''
);



/* Contains mail server filters.
    FilterID    - Flter ID, GUID value is suggested.
    Cost        - Filter cost, lower values are processed first.
    Description - Filter description.
    Assembly    - Filter assembly name.
    ClassName   - Filter class name.
    Type        - Filter type.
    Enabled     - Specifies if filter is enabled.
*/
Create table lsFilters(
        FilterID    varchar(100) UNIQUE Default ''   ,
        Cost        bigint              Default 0    ,
        Description varchar(100)        Default ''   ,
        Assembly    varchar(100)        Default ''   ,
        ClassName   varchar(100)        Default ''   ,
        Type        varchar(100)        Default ''   ,
        Enabled     boolean             Default TRUE
);



/* Contains mail server mailing lists.
    MailingListID   - Mailing list ID, GUID value is suggested.
    DomainName      - Not used FIX ME:
    MailingListName - Mailing list name.
    Description     - Mailing list description.
    Enabled         - Specifies if mailing list is enabled.
*/
Create table lsMailingLists(        
        MailingListID   varchar(100) UNIQUE Default '',
        DomainName      varchar(100)        Default '',
        MailingListName varchar(100)        Default '',
        Description     varchar(100)        Default '',
        Enabled         boolean             Default TRUE
);



/* Contains mailing list members.
    MailingListID - Owner mailing list ID.
    Address       - Mailing list member.
*/
Create table lsMailingListAddresses(        
        AddressID     varchar(100) Default '',
        MailingListID varchar(100) Default '',
        Address       varchar(100) Default ''
);



/* Contains mailing list ACL entries. ACL entry specifies who can
   access mailing list.
    MailingListID - Owner mailing list ID.
    UserOrGroupID - User or group ID who can access mailing list.
*/
Create table lsMailingListACL(        
        MailingListID varchar(100) Default '',
        UserOrGroupID varchar(100) Default ''
);



/* Contains mail server routing entries.
    RouteID     - Route ID, GUID value is suggested.
    Cost        - Route cost, lower values are processed first.
    Enabled     - Specifies if route is enabled.
    Description - Route description.
    Pattern     - Route match pattern.
    Action      - Route action.
    ActionData  - Route action data.
*/
Create table lsRouting(        
        RouteID     varchar(100) UNIQUE Default '',
        Cost        bigint              Default 0,
        Enabled     boolean             Default TRUE,
        Description varchar(100)        Default '',
        Pattern     varchar(100)        Default '',
        Action      int                 Default 0,
	ActionData  bytea
);



/* Contains mail server IP security entries.
    ID          - Security entry ID, GUID value is suggested.
    Enabled     - Specifies if security entry is enabled.
    Description - Security entry description.
    Service     - Service type.
    Action      - Action type.
    StartIP     - Range start IP address.
    EndIP       - Range end IP address.
*/
Create table lsIPSecurity(
        ID          varchar(100) UNIQUE Default '',
        Enabled     boolean             Default TRUE,
        Description varchar(100)        Default '',
        Service     int                 Default 0,
        Action      int                 Default 0,
        StartIP     varchar(100)        Default '',
        EndIP       varchar(100)        Default ''
);



/* Contains system settings.
*/
Create table lsSettings(        
        Settings bytea
);



/* Contains users default folders
    FolderName - Users default folder name.
    Permanent  - Specifies if folder is permanent, users can't delete it.
*/
Create table lsUsersDefaultFolders(
    FolderName varchar(200) UNIQUE Default '',
    Permanent  boolean             Default TRUE
);



/* Contains user remote servers.
    ServerID       - Remote server iD, GUID value is usggested.
    UserID         - Owner user ID.
    Description    - Remote server escription.
    RemoteServer   - Remote server name or IP address.
    RemotePort     - Remote server port.
    RemoteUserName - Remote server user name.
    RemotePassword - Remote server password.
    UseSSL         - Specifies if remote server is connected via SSL.
    Enabled        - Specifies if remote server is enabled.
*/
Create table lsUserRemoteServers(        
        ServerID       varchar(100) UNIQUE Default '',
        UserID         varchar(100)        Default '',
        Description    varchar(100)        Default '',
        RemoteServer   varchar(100)        Default '',
        RemotePort     int                 Default 110,
        RemoteUserName varchar(100)        Default '',
        RemotePassword varchar(100)        Default '',
        UseSSL         boolean             Default FALSE,
        Enabled        boolean             Default TRUE
);



/* Contains user message rules.
    UserID          - Rule owner user ID.
    RuleID          - Rule ID, GUID value is suggested.
    Cost            - Rule cost, lower values are processed first.
    Enabled         - Specifies if rule is enabled.
    CheckNextRuleIf - Specifies when next rule is checked.
    Description     - Rule description.
    MatchExpression - Rule match expression.
*/
Create table lsUserMessageRules(
        UserID          varchar(100)        Default '',
        RuleID          varchar(100) UNIQUE Default '',
        Cost            bigint              Default 0,
        Enabled         boolean             Default TRUE,
        CheckNextRuleIf int                 Default 0,
        Description     varchar(400)        Default '',
        MatchExpression bytea
);



/* Contains user message rule actions.
    UserID      - Owner user ID.
    RuleID      - Owner rule ID.
    ActionID    - Action ID, GUID value is suggested.
    Description - Action description.
    ActionType  - Action type.
    ActionData  - Actioon data.
*/
Create table lsUserMessageRuleActions(
        UserID          varchar(100) Default '',
        RuleID          varchar(100) Default '',
        ActionID        varchar(100) Default '',
        Description     varchar(400) Default '',
        ActionType      int          Default 0,
        ActionData      bytea
);



/* Contains mail server users.
    UserID - User ID, GUID value is suggested.
    Enabled       - Specifies if user is enabled.
    FullName      - User full name.
    UserName      - User login name.
    Password      - User password.
    Description   - User description.
    DomainName    - FIX ME:
    Mailbox_Size  - Maximum mailbox size.
    Permissions   - Specifies user permissions.
    CreationTime  - Time when user created.
    LastLoginTime - Time when user did last login.
*/
Create table lsUsers(        
        UserID        varchar(100) UNIQUE Default '',
        Enabled       boolean             Default TRUE,
        FullName      varchar(100)        Default '',
        UserName      varchar(100)        Default '',
        Password      varchar(100)        Default '',
        Description   varchar(100)        Default '',
        DomainName    varchar(100)        Default '',
        Mailbox_Size  bigint              Default 0,
        Permissions   int                 Default 255,
        CreationTime  timestamp           Default now(),
        LastLoginTime timestamp           Default now()
);



/* Contains users folders.
    FolderID       - Folder ID, GUID value is suggested.
    UserID         - Folder owner user ID:
    FolderName     - Folder name.
    MessageUidNext - Folder next message UID holder.
*/
Create table lsUserFolders(
        FolderID       varchar(100) UNIQUE Default '',
        UserID         varchar(100)        Default '',
        FolderName     varchar(300)        Default '',
        MessageUidNext bigint              Default 1,
        CreationTime timestamp             Default now()
);



/* Contains user subscribed IMAP folders.
    UserID     - User ID.
    FolderName - Subscribed folder name.
*/
Create table lsIMAPSubscribedFolders(        
        UserID     varchar(100) Default '',
        FolderName varchar(100) Default ''
);



/* Contains users folders messages.
    UserID       - User ID.
    FolderID     - Folder ID.
    MessageID    - Message ID.
    UID          - Message IMAP UID.
    Date         - Message IMAP internal date.
    Size         - Message size in bytes.
    MessageFlags - Message flags.
    Data         - Message data.
    TopLines     - Message POP3 TOP lines.
*/
Create table lsMailStore(
        UserID       varchar(100)        Default '',
        FolderID     varchar(100)        Default '',
        MessageID    varchar(100) UNIQUE Default '',
        UID          bigint              Default 1 ,
        Date         timestamp              ,
        Size         bigint              Default 0 ,
        MessageFlags bigint              Default 0 ,
        Data         bytea                         ,
        TopLines     bytea                         ,
        ImapEnvelope bytea                         , 
        ImapBody     bytea                  
);



/* This table holds recycle bin messages
    MessageID  - Message ID.
    DeleteTime - Date time when message was deleted.
    User       - User whos message it is.
    Folder     - Original folder where message was.
    Size       - Message size in bytes.
    Envelope   - Message IMAP Envelope string.
    Data       - Message data.
*/
create table lsRecycleBin(
    MessageID  varchar(100)  DEFAULT '',
    DeleteTime timestamp              ,
    "User"     varchar(200)  DEFAULT '',
    Folder     varchar(500)  DEFAULT '',
    Size       bigint        DEFAULT 0,
    Envelope   varchar(2000) DEFAULT '',
    Data       bytea
);



/* Holds Recycle Bin settings.
    DeleteToRecycleBin  - Specifies if messages must be deleted to recycle bin.
    DeleteMessagesAfter - Specifies after what days messages will be deleted.
*/
create table lsRecycleBinSettings(
    DeleteToRecycleBin  boolean Default FALSE,
    DeleteMessagesAfter integer Default 1
);



/* Contains user folder ACL entries.
    FolderOwnerID - Folder owner user ID.
    FolderID      - Folder ID.
    UserOrGroupID - User or group ID whos permissions are.
    Permissions   - User or group permissions.
*/
Create table lsIMAP_ACL(
        FolderOwnerID varchar(100) Default '',
        FolderID      varchar(100) Default '',
        UserOrGroupID varchar(100) Default '',
        Permissions   bigint       Default 0
);



/* Contains mail server global message rules.
    RuleID          - Rule ID, GUID value is suggested.
    Cost            - Rule cost, lower values are processed first.
    Enabled         - Specifies if global message rule is enabled.
    CheckNextRuleIf - Specifies when next rule is checked.
    Description     - Global message rule description.
    MatchExpression - Match expression.
*/
Create table lsGlobalMessageRules(  
        RuleID          varchar(100) UNIQUE Default ''  ,
        Cost            bigint              Default 0   ,
        Enabled         boolean             Default TRUE,
        CheckNextRuleIf int                 Default 0   ,
        Description     varchar(400)        Default ''  ,
        MatchExpression bytea
);



/* Contains global message rule actions.
    RuleID      - Action owner rule ID.
    ActionID    - Action ID, GUID value is suggested.
    Description - Action description.
    ActionType  - Action type.
    ActionData  - Action data.
*/
Create table lsGlobalMessageRuleActions(
        RuleID          varchar(100) Default '',
        ActionID        varchar(100) Default '',
        Description     varchar(400) Default '',
        ActionType      int          Default 0 ,
        ActionData      bytea
);



/* Contains mail server groups.
    GroupID     - Group ID, GUID value is suggested.
    GroupName   - Group name.
    Description - Group description.
    Enabled     - Specifies if group is enabled.
*/
Create table lsGroups(
        GroupID         varchar(100) UNIQUE Default '',
        GroupName       varchar(100)        Default '',
        Description     varchar(400)        Default '',
        Enabled         boolean             Default TRUE
);



/* Contains group members.
    GroupID     - Owner group ID.
    UserOrGroup - User or group name which to add as group member.
*/
Create table lsGroupMembers(
        GroupID        varchar(100) Default '',
        UserOrGroupID  varchar(100) Default ''
);



/* Contains shared folders roots.
    RootID        - Shared folder root ID, GUID value is suggested.
    Enabled       - Specified if shared root folder is enabled.
    Folder        - Shared root folder name.
    Description   - Shared root folder description.
    RootType      - Shared root folder type.
    BoundedUser   - Shared root folder bounded user.
    BoundedFolder - Shared root folder bouned user folder.
*/
CREATE table lsSharedFoldersRoots(
        RootID         varchar(100) UNIQUE Default '',
        Enabled        boolean             Default TRUE,
        Folder         varchar(400)        Default '',
        Description    varchar(400)        Default '',
        RootType       int                 Default 0,
        BoundedUser    varchar(100)        Default '',
        BoundedFolder  varchar(400)        Default ''
);

