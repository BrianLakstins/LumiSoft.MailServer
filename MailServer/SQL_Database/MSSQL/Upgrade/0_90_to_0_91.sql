

drop table lsRouting

go

Create table lsRouting(        
        RouteID     nvarchar(100) Default (''),
        Cost        bigint        Default (0),
	Enabled     bit           Default (1),
	Description nvarchar(100) Default (''),
        Pattern     nvarchar(100) Default (''),
	Action      int           Default (0),
	ActionData  image         
)

go

drop table lsUserMessageRules

go

Create table lsUserMessageRules(
	UserID          nvarchar(100) Default (''),
        RuleID          nvarchar(100) Default (''),
        Cost            bigint        Default (0),
        Enabled         bit           Default (1),
        CheckNextRuleIf int           Default (0),
        Description     nvarchar(400) Default (''),
        MatchExpression image
)

go

Create table lsUserMessageRuleActions(
	UserID          nvarchar(100) Default (''),
        RuleID          nvarchar(100) Default (''),
        ActionID        nvarchar(100) Default (''),
        Description     nvarchar(400) Default (''),
        ActionType      int           Default (0),
        ActionData      image
)

go

ALTER TABLE lsUsers ADD [Permissions] int DEFAULT 255 NOT NULL

go

drop table lsSecurity

go

Create table lsIPSecurity(
        ID          nvarchar(100) Default (''),
	Enabled     bit           Default (1),
        Description nvarchar(100) Default (''),
        Service     int           Default (''),
	Action      int           Default (''),
	StartIP     nvarchar(100) Default (0),
	EndIP       nvarchar(100) Default (0)        
)


go

Create table lsUsersDefaultFolders(
    FolderName varchar(200) UNIQUE Default (''),
    Permanent  bit                 Default (1)
)

go

/* This table holds recycle bin messages
    MessageID  - Message ID.
    DeleteTime - Date time when message was deleted.
    User       - User whos message it is.
    Folder     - Original folder where message was.
    Subject    - Message subject.
    Data       - Message data.
*/
create table lsRecycleBin(
    MessageID  nvarchar(100) DEFAULT (''),
    DeleteTime datetime      DEFAULT (getdate()),
    [User]     nvarchar(200) DEFAULT (''),
    Folder     nvarchar(500) DEFAULT (''),    
    Subject    nvarchar(500) DEFAULT (''),
    Data       image,
)

go

/* Holds Recycle Bin settings.
    DeleteToRecycleBin  - Specifies if messages must be deleted to recycle bin.
    DeleteMessagesAfter - Specifies after what days messages will be deleted.
*/
create table lsRecycleBinSettings(        
    DeleteToRecycleBin  bit Default (0),
    DeleteMessagesAfter int Default (1)
)

go

ALTER TABLE lsUsers ADD [CreationTime] datetime DEFAULT getdate()

go

ALTER TABLE lsIMAPFolders ADD [CreationTime] datetime DEFAULT getdate()

go

ALTER TABLE lsRecycleBin ADD Size bigint DEFAULT (0)

go

ALTER TABLE lsRecycleBin ADD Envelope nvarchar(2000) DEFAULT ('')

go

ALTER TABLE lsUsers ADD [LastLoginTime] datetime DEFAULT getdate()

go
