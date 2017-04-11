


/* Adds new domain.
    _domainID    - Domain ID. Guid value is suggested.
    _domainName  - Domain name.
    _description - Domain description.
*/
CREATE OR REPLACE FUNCTION lspr_AddDomain(
    _domainID    varchar,
    _domainName  varchar,
    _description varchar
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF NOT EXISTS(select * from lsDomains where (DomainID = _domainID)) THEN
        IF NOT EXISTS(select * from lsDomains where (lower(DomainName) = lower(_domainName))) THEN
            INSERT INTO lsDomains (DomainID,DomainName,Description)
                VALUES (_domainID,_domainName,_description);
        ELSE
            errorText := 'Domain with specified name "' || _domainName || '" already exists !';
		    RAISE EXCEPTION '%',errorText;
	    END IF;
    ELSE
        errorText := 'Domain with specified ID "' || _domainID || '" already exists !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Adds new filter.
    _filterID    - Fileter ID. Guid value suggested.
    _description - Filter description.
    _type        - Filter type.
    _assembly    - Filter assambly name.
    _className   - Filter class name.
    _cost        - Filter cost. Lower values are processed first.
    _enabled     - Specifies if filter is enabled.
*/
CREATE OR REPLACE FUNCTION lspr_AddFilter(
    _filterID    varchar,
    _description varchar,
    _type        varchar,
    _assembly    varchar,
    _className   varchar,
    _cost        bigint,
    _enabled     boolean
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF NOT EXISTS(select * from lsFilters where (FilterID = _filterID)) THEN
	    INSERT INTO lsFilters (FilterID,Description,Type,Assembly,ClassName,Cost,Enabled)
	        VALUES (_filterID,_description,_type,_assembly,_className,_cost,_enabled);
    ELSE
        errorText := 'Filter with specified ID "' || _filterID || '" already exists !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Adds new global message rule.
    _ruleID          - Rule ID. Guid value suggested.
    _cost            - Rule cost. Lower values are processed first.
    _enabled         - Specifies if filter is enabled.
    _checkNextRule   - Specifies when next rule is processed.
    _description     - Global message rule description.
    _matchExpression - Match expression.
*/
CREATE OR REPLACE FUNCTION lspr_AddGlobalMessageRule(
    _ruleID          varchar,
    _cost            bigint,
    _enabled         boolean,
    _checkNextRule   integer,
    _description     varchar,
    _matchExpression bytea
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF NOT EXISTS(select * from lsGlobalMessageRules where (RuleID = _ruleID)) THEN
		INSERT INTO lsGlobalMessageRules (RuleID,Cost,Enabled,CheckNextRuleIf,Description,MatchExpression)
			VALUES (_ruleID,_cost,_enabled,_checkNextRule,_description,_matchExpression);
	ELSE
		errorText := 'Rule with specified ID "' || _ruleID || '" already exists !';
		RAISE EXCEPTION '%',errorText;
	END IF;
END;

$$ LANGUAGE plpgsql;



/* Adds global message rule action.
    _ruleID      - Action owner rule ID.
    _actionID    - Action ID. Guid value is suggested.
    _description - Action description.
    _actionType  - Action type.
    _actionData  - Action data.
*/
CREATE OR REPLACE FUNCTION lspr_AddGlobalMessageRuleAction(
    _ruleID      varchar,
	_actionID    varchar,
	_description varchar,
	_actionType  integer,
	_actionData  bytea
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF NOT EXISTS(select * from lsGlobalMessageRuleActions where (RuleID = _ruleID AND ActionID = _actionID)) THEN
		INSERT INTO lsGlobalMessageRuleActions (RuleID,ActionID,Description,ActionType,ActionData)
			VALUES (_ruleID,_actionID,_description,_actionType,_actionData);
	ELSE
		errorText := 'Action with specified ID "' || _actionID || '" already exists !';
		RAISE EXCEPTION '%',errorText;
	END IF;
END;

$$ LANGUAGE plpgsql;



/* Adds new group.
    _groupID     - Group ID. Guid value is suggested.
    _groupName   - Group name.
    _description - Group description.
    _enabled     - Specifies if group is enabled.
*/
CREATE OR REPLACE FUNCTION lspr_AddGroup(
    _groupID     varchar,
	_groupName   varchar,
	_description varchar,
	_enabled     boolean
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    -- Ensure that group ID won't exist already.
	IF EXISTS(select * from lsGroups where (GroupID = _groupID)) THEN
		errorText := 'Invalid group ID, specified group ID ' || _groupID || ' already exists !';
		RAISE EXCEPTION '%',errorText;
	END IF;

	-- Ensure that group name won't exist already.
	IF EXISTS(select * from lsGroups where (lower(GroupName) = lower(_groupName))) THEN
		errorText := 'Invalid group name, specified group ''' || _groupName || ''' already exists !';
		RAISE EXCEPTION '%',errorText;
	-- Ensure that user name with groupName doen't exist.
	ELSIF EXISTS(select * from lsUsers where (lower(UserName) = lower(_groupName))) THEN
		errorText := 'Invalid group name, user with specified name ''' || _groupName || ''' already exists !';
		RAISE EXCEPTION '%',errorText;
	END IF;
	
	-- Insert group
	INSERT INTO lsGroups (GroupID,GroupName,Description,Enabled)
		VALUES (_groupID,_groupName,_description,_enabled);
END;

$$ LANGUAGE plpgsql;



/* Adds group member.
    _groupName   - Member owner group.
    _userOrGroup - Member user or group name.
*/
CREATE OR REPLACE FUNCTION lspr_AddGroupMember(
    _groupName    varchar,
    _userOrGroup  varchar
) RETURNS void

AS $$

DECLARE
   _groupID       varchar;
   _userOrGroupID varchar;
   errorText      varchar;

BEGIN
    -- Ensure that group exists.
	IF NOT EXISTS(select * from lsGroups where (lower(GroupName) = lower(_groupName))) THEN
		errorText := 'Invalid group name, specified group ''' || _groupName || ''' doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
	END IF;

	-- Don't allow to add same group as group member.
	IF _groupName = _userOrGroup THEN	
		errorText := 'Invalid group member, can''t add goup itself as same group member !';
		RAISE EXCEPTION '%',errorText;
	END IF;

	-- Get groupID
	_groupID := (select GroupID from lsGroups where (lower(GroupName) = lower(_groupName)));
	
	-- See if user
    IF EXISTS(select UserID from lsUsers where (lower(UserName) = lower(_userOrGroup))) THEN
        _userOrGroupID := (select UserID from lsUsers where (lower(UserName) = lower(_userOrGroup)));
    -- See if group
    ELSIF EXISTS(select GroupID from lsGroups where (lower(GroupName) = lower(_userOrGroup))) THEN
        _userOrGroupID := (select GroupID from lsGroups where (lower(GroupName) = lower(_userOrGroup)));
    -- Error
    ELSE
        errorText := ('Invalid user or group, ' || _userOrGroup || ' doesn''t exist');
		RAISE EXCEPTION '%',errorText;
    END IF;

	-- Ensure that group member doesn't exist.
	IF EXISTS(select * from lsGroupMembers where (GroupID = _groupID AND UserOrGroupID = _userOrGroupID)) THEN
		errorText := 'Invalid group member, specified group member ''' || _userOrGroup || ''' already exists !';
		RAISE EXCEPTION '%',errorText;
	END IF;
	
	-- Insert group member
	insert into lsGroupMembers (GroupID,UserOrGroupID)
		values (_groupID,_userOrGroupID);
END;

$$ LANGUAGE plpgsql;



/* Adds new mailing list.
    _mailingListID   - Mailing list ID. Guid value is suggested.
    _mailingListName - Mailing list name.
    _description     - Maling list description.
    _domainName      - Not used. FIX ME:
    _enabled         - Specifies if mailing list is enabled.
*/
CREATE OR REPLACE FUNCTION lspr_AddMailingList(
    _mailingListID	 varchar,
    _mailingListName varchar,
    _description     varchar,
    _domainName      varchar,
    _enabled         boolean
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF NOT EXISTS(select * from lsMailingLists where (MailingListID = _mailingListID)) THEN
	    IF NOT EXISTS(select * from lsMailingLists where (lower(MailingListName) = lower(_mailingListName))) THEN
		    insert into lsMailingLists (
                MailingListID,
                MailingListName,
                Description,
                DomainName,
                Enabled
            )
		    values (
                _mailingListID,
                _mailingListName,
                _description,
                _domainName,
                _enabled
            );
	    ELSE
		    errorText := 'Mailing list with specified name "' || _mailingListName || '" already exists !';
		    RAISE EXCEPTION '%',errorText;
	    END IF;
    ELSE
	    errorText := 'Mailing list with specified ID "' || _mailingListID || '" already exists !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Adds mailing list ACL entry. ACL entry specifies who can access mailing list.
    _mailingListName - Mailing list name to where to add ACL entry.
    _userOrGroup     - User or group name who to add.
*/
CREATE OR REPLACE FUNCTION lspr_AddMailingListACL(
    _mailingListName varchar,
	_userOrGroup     varchar
) RETURNS void

AS $$

DECLARE
   _userOrGroupID varchar;
   _mailingListID varchar;
   errorText      varchar;

BEGIN
    -- Ensure that mailing list exists.
	IF NOT EXISTS(select * from lsMailingLists where (lower(MailingListName) = lower(_mailingListName))) THEN
		errorText := 'Invalid mailing list name, specified mailing list ''' || _mailingListName || ''' doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
	END IF;

	-- Get mailing list ID
	_mailingListID := (select MailingListID from lsMailingLists where (lower(MailingListName) = lower(_mailingListName)));
	
	-- See if built-in user or group
	IF lower(_userOrGroup) = 'anyone' THEN
	    _userOrGroupID := 'anyone';
    ELSIF lower(_userOrGroup) = 'authenticated users' THEN
        _userOrGroupID := 'authenticated users';
    -- See if user
    ELSIF EXISTS(select UserID from lsUsers where (lower(UserName) = lower(_userOrGroup))) THEN
        _userOrGroupID := (select UserID from lsUsers where (lower(UserName) = lower(_userOrGroup)));
    -- See if group
    ELSIF EXISTS(select GroupID from lsGroups where (lower(GroupName) = lower(_userOrGroup))) THEN
        _userOrGroupID := (select GroupID from lsGroups where (lower(GroupName) = lower(_userOrGroup)));
    -- Error
    ELSE
        errorText := ('Invalid user or group, ' || _userOrGroup || ' doesn''t exist');
		RAISE EXCEPTION '%',errorText;
    END IF;
	
	-- Ensure that user or group already doesn't exist in list.
	IF EXISTS(select * from lsMailingListACL where (MailingListID = _mailingListID AND UserOrGroupID = _userOrGroupID)) THEN
		errorText := 'Invalid userOrGroup, specified userOrGroup ''' || _userOrGroup || '''already exist !';
		RAISE EXCEPTION '%',errorText;
	END IF;

	
	-- Insert group
	insert into lsMailingListACL (MailingListID,UserOrGroupID)
		values (_mailingListID,_userOrGroupID);
END;

$$ LANGUAGE plpgsql;



/* Adds mailing list member.
    _addressID - ??? FIX ME:
*/
CREATE OR REPLACE FUNCTION lspr_AddMailingListAddress(
    _addressID       varchar,
    _mailingListName varchar,
    _address         varchar
) RETURNS void

AS $$

DECLARE
   _mailingListID varchar;
   errorText      varchar;

BEGIN
    IF NOT EXISTS(select * from lsMailingListAddresses where (AddressID = _addressID)) THEN	
	    _mailingListID := (select MailingListID from lsMailingLists where (lower(MailingListName) = lower(_mailingListName)));

	    IF NOT exists(select * from lsMailingListAddresses where (MailingListID = _mailingListID AND Address = _address)) THEN
	        insert into lsMailingListAddresses (
                AddressID,
                MailingListID,
                Address
            )
            values (
                _addressID,
                _mailingListID,
                _address
            );
	    ELSE
		    errorText := 'Mailing list address with specified name "' || _address || '" already exists !';
		    RAISE EXCEPTION '%',errorText;
        END IF;
    ELSE
	    errorText := 'Mailing list address with specified ID "' || _addressID || '" already exists !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Adds new route.
    _routeID     - Route ID. Guid value is suggested.
    _cost        - Route cost. Lower values are processed first.
    _enabled     - Specifies if route is enabled.
    _description - Route description.
    _pattern     - Route match pattern.
    _action      - Route action.
    _actionData  - Route action data.
*/
CREATE OR REPLACE FUNCTION lspr_AddRoute(
    _routeID     varchar,
	_cost        bigint ,
	_enabled     boolean,
	_description varchar,
	_pattern     varchar,
	_action      integer,
	_actionData  bytea
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF NOT EXISTS(select * from lsRouting where (RouteID = _routeID)) THEN
	    IF NOT EXISTS(select * from lsRouting where (lower(Pattern) = lower(_pattern))) THEN
		    insert into lsRouting (RouteID,Cost,Enabled,Description,Pattern,Action,ActionData)
		    values (_routeID,_cost,_enabled,_description,_pattern,_action,_actionData);
	    ELSE
		    errorText := 'Route with specified pattern "' || _pattern || '" already exists !';
		    RAISE EXCEPTION '%',errorText;
	    END IF;
    ELSE
	    errorText := 'Route with specified ID "' || _routeID || '" already exists !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Adds new IP security entry.
    _id          - Security entry ID. Guid value is suggested.
    _enabled     - Specifies if security entry is enabled.
    _description - Security entry description.
    _service     - Service type.
    _action      - Action.
    _startIP     - Range start IP address.
    _endIP       - Range end IP address.
*/
CREATE OR REPLACE FUNCTION lspr_AddSecurityEntry(
    _id          varchar,
    _enabled     boolean,
    _description varchar,
    _service     integer,
    _action      integer,
    _startIP     varchar,
    _endIP       varchar
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF NOT EXISTS(select * from lsIPSecurity where (ID = _id)) THEN
	    insert into lsIPSecurity (ID,Enabled,Description,Service,Action,StartIP,EndIP)
        values (_id,_enabled,_description,_service,_action,_startIP,_endIP);
    ELSE
	    errorText := 'Security entry with specified ID "' || _id || '" already exists !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Adds new shared root folder.
    _rootID        - Shared root folder ID. Guid value is suggested.
    _enabled       - Specifies if shared root folder is enabled.
    _folder        - Shared root folder name.
    _description   - Shared root folder description.
    _rootType      - Shared root folder type.
    _boundedUser   - Shared root folder bounded user.
    _boundedFolder - Shared root folder bounded user folder.
*/
CREATE OR REPLACE FUNCTION lspr_AddSharedFolderRoot(
    _rootID        varchar,
	_enabled       boolean,
	_folder        varchar,
	_description   varchar,
	_rootType      integer,
	_boundedUser   varchar,
	_boundedFolder varchar
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    -- Ensure that root ID won't exist already.
	IF EXISTS(select * from lsSharedFoldersRoots where (RootID = _rootID)) THEN
		errorText := 'Invalid root ID, specified root ID ''' || _rootID || ''' already exists !';
		RAISE EXCEPTION '%',errorText;
	END IF;

	-- Ensure that root folder name won't exist already.
	IF EXISTS(select * from lsSharedFoldersRoots where (lower(Folder) = lower(_folder))) THEN
		errorText := 'Invalid root folder name, specified folder ''' || _folder || ''' already exists !';
		RAISE EXCEPTION '%',errorText;
	END IF;
	
	-- Insert root folder
	insert into lsSharedFoldersRoots (
        RootID,
        Enabled,
        Folder,
        Description,
        RootType,
        BoundedUser,
        BoundedFolder
    )
    values (
        _rootID,
        _enabled,
        -folder,
        _description,
        _rootType,
        _boundedUser,
        _boundedFolder
    );
END;

$$ LANGUAGE plpgsql;



/* Adds new user.
    _userID      - User ID. Guid value is suggested.
    _fullName    - User full name.
    _userName    - User login name.
    _password    - User password.
    _description - User description.
    _domainName  - Not used. FIX ME:
    _mailboxSize - User maximum mailbox size.
    _enabled     - Specifies if user is enabled.
    _permissions - User permissions.
*/
CREATE OR REPLACE FUNCTION lspr_AddUser(
    _userID	     varchar,
    _fullName    varchar,
    _userName    varchar,
    _password    varchar,
    _description varchar,
    _domainName  varchar,
    _mailboxSize integer,
    _enabled     boolean,
    _permissions integer
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF NOT EXISTS(select * from lsUsers where (UserID = _UserID)) THEN
	    IF NOT EXISTS(select * from lsUsers where (lower(UserName) = lower(_UserName))) THEN
		    insert into lsUsers (UserID,FullName,UserName,Password,Description,Mailbox_Size,DomainName,Enabled,Permissions,CreationTime)
                values (_userID,_fullName,_userName,_password,_description,_mailboxSize,_domainName,_enabled,_permissions,now());
	    ELSE
		    errorText := 'User with specified name "' || _userName || '" already exists !';
		    RAISE EXCEPTION '%',errorText;
	    END IF;
    ELSE
	    errorText := 'User with specified ID "' || _userID || '" already exists !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Adds new email address.
    _localPart  - Email address local part. localpart[@domain]
    _domainName - Email domain.
    _ownerID    - Email address owner user ID.
*/
CREATE OR REPLACE FUNCTION lspr_AddEmailAddress(
    _localPart  varchar,
    _domainName varchar,
    _ownerID    varchar
) RETURNS void

AS $$

DECLARE
   _domainID     varchar;
   _emailAddress varchar;
   errorText     varchar;

BEGIN
    _domainID     := (select DomainID from lsDomains where (lower(DomainName) = lower(_domainName)));
    _emailAddress := _localPart || '@' || _domainName;
    
    IF EXISTS(select * from lsEmailAddresses where (lower(LocalPart) = lower(_localpart) AND DomainID = _domainID)) THEN
        errorText := 'Specified email address "' || _emailAddress || '" already exists !';
		RAISE EXCEPTION '%',errorText;
    END IF;
    
    insert into lsEmailAddresses (
        LocalPart,
        DomainID,
        OwnerID
    )
    values (
        _localPart,
        _domainID,
        _ownerID
    );
END;

$$ LANGUAGE plpgsql;



/* Adds user message rule.
    _userID          - Rule owner user name.
    _ruleID          - Rule ID. Guid value is suggested.
    _cost            - Rule cost. Lower values are processed first.
    _enabled         - Specifies if rule is enabled.
    _checkNextRule   - Specifies when next rule is checked.
    _description     - Rule description.
    _matchExpression - Match expression.
*/
CREATE OR REPLACE FUNCTION lspr_AddUserMessageRule(
    _userID          varchar,
	_ruleID          varchar,
	_cost            bigint ,
	_enabled         boolean,
	_checkNextRule   integer,
	_description     varchar,
	_matchExpression bytea
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF NOT EXISTS(select * from lsUserMessageRules where (RuleID = _ruleID)) THEN
		insert into lsUserMessageRules (
            UserID,
            RuleID,
            Cost,
            Enabled,
            CheckNextRuleIf,
            Description,
            MatchExpression
        )
		values (
            _userID,
            _ruleID,
            _cost,
            _enabled,
            _checkNextRule,
            _description,
            _matchExpression
       );
	ELSE
		errorText := 'Rule with specified ID "' || _ruleID || '" already exists !';
		RAISE EXCEPTION '%',errorText;
	END IF;
END;

$$ LANGUAGE plpgsql;



/* Adds user message rule action.
    _userID      - Rule owner user.
    _ruleID      - Action owner rule.
    _actionID    - Action ID. Guid value is suggested.
    _description - Action description.
    _actionType  - Action type.
    _actionData  - Action data.
*/
CREATE OR REPLACE FUNCTION lspr_AddUserMessageRuleAction(
    _userID      varchar,
	_ruleID      varchar,
	_actionID    varchar,
	_description varchar,
	_actionType  integer,
	_actionData  bytea
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF NOT EXISTS(select * from lsUserMessageRuleActions where (RuleID = _ruleID AND ActionID = _actionID)) THEN
		insert into lsUserMessageRuleActions (
            UserID,
            RuleID,
            ActionID,
            Description,
            ActionType,
            ActionData
        )
		values (
            _userID,
            _ruleID,
            _actionID,
            _description,
            _actionType,
            _actionData
        );
	ELSE
		errorText := 'Action with specified ID "' || _actionID || '" already exists !';
		RAISE EXCEPTION '%',errorText;
	END IF;
END;

$$ LANGUAGE plpgsql;



/* Adds user remote server.
    _serverID       - Remote server ID. Guid value is suggested.
    _userName       - Remote server owner user.
    _description    - Remote server description.
    _remoteServer   - Remote server name or IP address.
    _remotePort     - Remote server port.
    _remoteUserName - Remote server user name.
    _remotePassword - Remote server password.
    _useSSL         - Specifies if SSL must be used to connect to remote server.
    _enabled        - Specifies if remote server is enabled.
*/
CREATE OR REPLACE FUNCTION lspr_AddUserRemoteServer(
    _serverID       varchar,
	_userName       varchar,
	_description    varchar,
	_remoteServer   varchar,
	_remotePort     integer,
	_remoteUserName varchar,
	_remotePassword varchar,
	_useSSL         boolean,
	_enabled        boolean
) RETURNS void

AS $$

DECLARE
   _userID   varchar;
   errorText varchar;

BEGIN
    IF NOT EXISTS(select * from lsUserRemoteServers where (ServerID = _serverID)) THEN
	    -- Get userID
	    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));

	    insert into lsUserRemoteServers (
		    ServerID,
		    UserID,
		    Description,
		    RemoteServer,
	        RemotePort,
		    RemoteUserName,
		    RemotePassword,
		    UseSSL,
		    Enabled
        )
	    values (
		    _serverID,
		    _userID,
		    _description,
		    _remoteServer,
		    _remotePort,
		    _remoteUserName,
		    _remotePassword,
		    _useSSL,
		    _enabled
	    );
    ELSE
	    errorText := 'User remote server with specified ID "' || _serverID || '" already exists !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Adds users default folder.
    _folderName - Users default folder name.
    _permanent  - Specifies if folder is permanent, users can't delete it.
*/
CREATE OR REPLACE FUNCTION lspr_AddUsersDefaultFolder(
    _folderName     varchar,
	_permanent      boolean
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF(EXISTS(select * from lsUsersDefaultFolders where (FolderName = _folderName))) THEN
        errorText := 'Users default folder with specified name ''' || _folderName || ''' already exists !';
        RAISE EXCEPTION '%',errorText;
        return;
    END IF;

    insert into lsUsersDefaultFolders (FolderName,Permanent)
    values (_folderName,_permanent);
END;

$$ LANGUAGE plpgsql;



/* Creates specified user folder.
    _folderID - Folder ID. GUID value is suggested.
    _userName - User whre to create folder.
    _folder   - Folder name with path.
*/
CREATE OR REPLACE FUNCTION lspr_CreateFolder(
    _folderID varchar,
    _userName varchar,
    _folder   varchar
) RETURNS void

AS $$

DECLARE
   _userID   varchar;
   errorText varchar;

BEGIN
    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));

    IF EXISTS(select * from lsUserFolders where (UserID = _userID AND lower(FolderName) = lower(_folder))) THEN
        errorText := 'Folder(' || _folder  || ') already exists';
        RAISE EXCEPTION '%',errorText;
    ELSE
	    insert into lsUserFolders (UserID,FolderID,FolderName,MessageUidNext,CreationTime)
        values (_userID,_folderID,_folder,1,now());
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Deletes specified domain.
    _domainID - Domain ID.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteDomain(
    _domainID varchar
) RETURNS void

AS $$

BEGIN
    delete from lsEmailAddresses where (DomainID = _domainID);
    delete from lsDomains where (DomainID = _domainID);
END;

$$ LANGUAGE plpgsql;



/* Deletes spcified filter.
    _filterID - Filter ID.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteFilter(
    _filterID varchar
) RETURNS void

AS $$

BEGIN
    delete from lsFilters where (FilterID = _FilterID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified folder.
    _folderOwnerUser - Folder owner user.
    _folderName      - Folder name with path.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteFolder(
    _folderOwnerUser varchar,
    _folderName      varchar
) RETURNS void

AS $$

DECLARE
   _userID   varchar;
   _folderID varchar;
   errorText varchar;
   r         lsUserFolders%ROWTYPE;

BEGIN
    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_folderOwnerUser)));

    -- Loop folder and it's child folders
    FOR r IN (select * from lsUserFolders where (UserID = _userID AND lower(FolderName) = lower(_folderName) OR lower(FolderName) LIKE lower(_folderName || '/%'))) LOOP
        _folderID := r.FolderID;
        
        -- Delete specified folder messages
	    delete from lsMailStore where (UserID = _userID AND FolderID = _folderID);

        -- Delete specified folder ACL
        delete from lsIMAP_ACL where (FolderOwnerUserID = _userID AND FolderID = _folderID);
        
        -- Delete specified folder
        delete from lsUserFolders where (UserID = _userID AND FolderID = _folderID);
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Deletes specified user permissions of specified folder.
    _folderOwnerUser - User who owns folder.
    _folderName      - Folder path.
    _userOrGroup     - User or group name which permissions to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteFolderACL(
    _folderOwnerUser varchar,
    _folderName      varchar,
    _userOrGroup     varchar
) RETURNS void

AS $$

DECLARE
   _folderOwnerID varchar;
   _folderID      varchar;
   _userOrGroupID varchar;
   errorText      varchar;

BEGIN
    _folderOwnerID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
    _folderID      := (select FolderID from lsUserFolders where (UserID = _folderOwnerID AND lower(FolderName) = lower(_folderName)));

    -- Handle built-in user anyone
    IF lower(_userOrGroup) = 'anyone' THEN
        _userOrGroupID := _userOrGroup;
    ELSE
        -- See if user
        IF EXISTS(select * from lsUsers where (lower(UserName) = lower(_userOrGroup))) THEN
            _userOrGroupID := (select * from lsUsers where (lower(UserName) = lower(_userOrGroup)));
        -- See if group
        ELSIF EXISTS(select * from lsGroups where (lower(GroupName) = lower(_userOrGroup))) THEN
            _userOrGroupID := (select * from lsGroups where (lower(GroupName) = lower(_userOrGroup)));
        -- Error
        ELSE
            errorText := ('Invalid user or group, ' || _userOrGroup || ' doesn''t exist');
		    RAISE EXCEPTION '%',errorText;
        END IF;
    END IF;

    delete from lsIMAP_ACL
    where (
        FolderOwnerUserID = _folderOwnerID AND
        FolderID          = _folderID      AND
        UserOrGroupID     = _userOrGroupID
    );
END;

$$ LANGUAGE plpgsql;



/* Deletes specified global message rule.
    _ruleID - Rule ID:
*/
CREATE OR REPLACE FUNCTION lspr_DeleteGlobalMessageRule(
    _ruleID varchar
) RETURNS void

AS $$

BEGIN
    -- Delete all specified rule Actions
	delete from lsGlobalMessageRuleActions where (RuleID = _ruleID);

	delete from lsGlobalMessageRules where (RuleID = _ruleID);
END;

$$ LANGUAGE plpgsql;



/* Deletes spcified global message rule action.
    _ruleID   - Action owner rule.
    _actionID - Action ID which to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteGlobalMessageRuleAction(
    _ruleID   varchar,
	_actionID varchar
) RETURNS void

AS $$

BEGIN
    delete from lsGlobalMessageRuleActions
    where (RuleID = _ruleID AND ActionID = _actionID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified group.
    _groupID - Group ID.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteGroup(
    _groupID varchar
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    -- Ensure that group ID exist.
	IF NOT EXISTS(select * from lsGroups where (GroupID = _groupID)) THEN
		errorText := 'Invalid group ID, specified group ID ''' || _groupID || ''' doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
	END IF;

	-- Delete group members.
	delete from lsGroupMembers where (GroupID = _groupID);

	-- Delete group.
	delete from lsGroups where (GroupID = _groupID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified group member.
    _groupName   - Group name.
    _userOrGroup - User or group name which to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteGroupMember(
    _groupName   varchar,
    _userOrGroup varchar
) RETURNS void

AS $$

DECLARE
   _groupID       varchar;
   _userOrGroupID varchar;
   errorText      varchar;

BEGIN
    _groupID := (select * from lsGroups where (lower(GroupName) = lower(_groupName)));
    -- Ensure that group exists.
	IF _groupID = null THEN
		errorText := 'Invalid group name, specified group ''' || _groupName || ''' doesn''t exist !';
	    RAISE EXCEPTION '%',errorText;
	END IF;
	
	-- See if user
    IF EXISTS(select UserID from lsUsers where (lower(UserName) = lower(_userOrGroup))) THEN
        _userOrGroupID := (select UserID from lsUsers where (lower(UserName) = lower(_userOrGroup)));
    -- See if group
    ELSIF EXISTS(select GroupID from lsGroups where (lower(GroupName) = lower(_userOrGroup))) THEN
        _userOrGroupID := (select GroupID from lsGroups where (lower(GroupName) = lower(_userOrGroup)));
    -- Error
    ELSE
        errorText := ('Invalid user or group, ' || _userOrGroup || ' doesn''t exist');
		RAISE EXCEPTION '%',errorText;
    END IF;

	-- Ensure that group member does exist.
	IF NOT EXISTS(select * from lsGroupMembers where (GroupID = _groupID AND UserOrGroupID = _userOrGroupID)) THEN
		errorText := 'Invalid group member, specified group member ''' || _userOrGroup || ''' already exists !';
	    RAISE EXCEPTION '%',errorText;
	END IF;

	-- Delete group member.
	delete from lsGroupMembers where (GroupID = _groupID AND UserOrGroupID = _userOrGroupID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified mailing list.
    _MailingListID - Mailing list ID which to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteMailingList(
    _MailingListID varchar
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    delete from lsMailingListAcl where (MailingListID = _mailingListID);
    delete from lsMailingListAddresses where (MailingListID = _mailingListID);
    delete from lsMailingLists where (MailingListID = _mailingListID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified mailing list ACL entry.
    _mailingListName - Mailing list name.
    _userOrGroup     - User or group which ACL to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteMailingListACL(
    _mailingListName varchar,
	_userOrGroup     varchar
) RETURNS void

AS $$

DECLARE
   _mailingListID varchar;
   _userOrGroupID varchar;
   errorText      varchar;

BEGIN
    -- Ensure that mailing list exists.
	IF NOT EXISTS(select * from lsMailingLists where (lower(MailingListName) = lower(_mailingListName))) THEN
		errorText := 'Invalid mailing list name, specified mailing list ''' || _mailingListName || ''' doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
	END IF;

	-- Get mailing list ID
	_mailingListID := (select MailingListID from lsMailingLists where (lower(MailingListName) = lower(_mailingListName)));
	
	-- See if built-in user or group
	IF lower(_userOrGroup) = 'anyone' THEN
	    _userOrGroupID := 'anyone';
    ELSIF lower(_userOrGroup) = 'authenticated users' THEN
        _userOrGroupID := 'authenticated users';
    -- See if user
    ELSIF EXISTS(select UserID from lsUsers where (lower(UserName) = lower(_userOrGroup))) THEN
        _userOrGroupID := (select UserID from lsUsers where (lower(UserName) = lower(_userOrGroup)));
    -- See if group
    ELSIF EXISTS(select GroupID from lsGroups where (lower(GroupName) = lower(_userOrGroup))) THEN
        _userOrGroupID := (select GroupID from lsGroups where (lower(GroupName) = lower(_userOrGroup)));
    -- Error
    ELSE
        errorText := ('Invalid user or group, ' || _userOrGroup || ' doesn''t exist');
		RAISE EXCEPTION '%',errorText;
    END IF;

	-- Delete ACL entry.
	delete from lsMailingListACL where (MailingListID = _mailingListID AND UserOrGroupID = _userOrGroupID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified mailing list member.
    _addressID - ??? MOVE TO member name ?? FIX ME:
*/
CREATE OR REPLACE FUNCTION lspr_DeleteMailingListAddress(
    _addressID varchar
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    delete from lsMailingListAddresses where (AddressID = _addressID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified user message.
    _userName   - Folder owner user name.
    _folderName - Folder name with path wich contains message.
    _messageID  - Message ID which to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteMessage(
    _userName   varchar,
    _folderName varchar,
    _messageID  varchar
) RETURNS void

AS $$

DECLARE
    _folderOwnerID varchar;
    _folderID      varchar;
    errorText      varchar;

BEGIN
    _folderOwnerID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
    _folderID      := (select FolderID from lsUserFolders where (UserID = _folderOwnerID AND FolderName = _folderName));
    
    delete from lsMailStore
    where (UserID = _folderOwnerID AND FolderID = _folderID AND MessageID = _messageID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified recycle bin message.
    _messageID - Message ID which to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteRecycleBinMessage(
    _messageID  varchar
) RETURNS void

AS $$

BEGIN
    delete from lsRecycleBin where(MessageID = _messageID);	
END;

$$ LANGUAGE plpgsql;



/* Deletes specified route.
    _routeID - Route ID whicg to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteRoute(
    _routeID varchar
) RETURNS void

AS $$

BEGIN
    delete from lsRouting where (RouteID = _routeID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified IP security entry.
    _securityID - IP security entry ID.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteSecurityEntry(
    _securityID varchar
) RETURNS void

AS $$

BEGIN
    delete from lsIPSecurity where (ID = _securityID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified shared folder root.
    _rootID - Shared root folder ID which to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteSharedFolderRoot(
    _rootID varchar
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    -- Ensure that root ID exist.
	IF NOT EXISTS(select * from lsSharedFoldersRoots where (RootID = _rootID)) THEN
		errorText := 'Invalid root ID, specified root ID ''' || _rootID || ''' doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
	END IF;

	-- Delete group.
	delete from lsSharedFoldersRoots where (RootID = _rootID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified user.
    _userID - User ID which to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteUser(
    _userID varchar
) RETURNS void

AS $$

BEGIN
    delete from lsMailingListAcl where (UserOrGroupID = _userID);
    delete from lsIMAP_ACL where (UserOrGroupID = _userID);
    delete from lsEmailAddresses where (OwnerID = _userID);
    delete from lsUserRemoteServers where (UserID = _userID);
    delete from lsUserMessageRules where (UserID = _userID);
    delete from lsIMAPSubscribedFolders where (UserID = _userID);
    delete from lsUsers where (UserID = _userID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified email address.
    _localPart  - Email local part. localpart[@domain]
    _domainName - Email domain name.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteEmailAddress(
    _localPart  varchar,
    _domainName varchar
) RETURNS void

AS $$

DECLARE
    _domainID varchar;

BEGIN
    _domainID := (select DomainID from lsDomains where (lower(DomainName) = lower(_domainName)));

    delete from lsEmailAddresses where (lower(LocalPart) = lower(_localPart) AND DomainID = _domainID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified user message rule.
    _userID - Message rule owner user ID.
    _ruleID - Rule ID which to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteUserMessageRule(
    _userID varchar,
    _ruleID varchar
) RETURNS void

AS $$

BEGIN
    -- Delete all specified rule Actions
	delete from lsUserMessageRuleActions where (UserID = _userID AND RuleID = _ruleID);

	delete from lsUserMessageRules where (UserID = _userID AND RuleID = _ruleID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified user message rule action.
    _userID   - Message rule owner user ID.
    _ruleID   - Rule ID which action to delete.
    _actionID - Action ID which to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteUserMessageRuleAction(
    _userID   varchar,
    _ruleID   varchar,
    _actionID varchar
) RETURNS void

AS $$

BEGIN
    delete from lsUserMessageRuleActions
        where (UserID = _userID AND RuleID = _ruleID AND ActionID = _actionID);
END;

$$ LANGUAGE plpgsql;



/* Deletes specified user remote server.
    _serverID - Remote server ID which to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteUserRemoteServer(
    _serverID varchar
) RETURNS void

AS $$

BEGIN
    delete from lsUserRemoteServers where (ServerID = _serverID);
END;

$$ LANGUAGE plpgsql;



/* Deletes users default folder.
    _folderName - Users default folder name which to delete.
*/
CREATE OR REPLACE FUNCTION lspr_DeleteUsersDefaultFolder(
    _folderName varchar
) RETURNS void

AS $$

DECLARE
    errorText varchar;

BEGIN
    -- Ensure that folder exist.
	IF(NOT EXISTS(select * from lsUsersDefaultFolders where (FolderName = _folderName))) THEN
		errorText := ('Users default folder with specified name ''' || _folderName || ''' doesn''t exists !');
		RAISE EXCEPTION '%',errorText;
	END IF;

	-- Delete folder.
	delete from lsUsersDefaultFolders where (FolderName = _folderName);
END;

$$ LANGUAGE plpgsql;



/* Check is specified domain exists.
    _domainName - Domain name.
*/
CREATE OR REPLACE FUNCTION lspr_DomainExists(
    _domainName varchar
) RETURNS setof lsDomains

AS $$

DECLARE
    r lsDomains%rowtype;

BEGIN
    FOR r IN (select * from lsDomains where (lower(DomainName) = lower(_domainName))) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Checks if specified user folder exists. This method also creates all
   default folders if they doesn't exist.
    _userName   - Folder owner user.
    _folderName - Folder name with path.
*/
CREATE OR REPLACE FUNCTION lspr_FolderExists(
    _userName   varchar,
    _folderName varchar
) RETURNS setof lsUserFolders

AS $$

DECLARE
    _userID varchar;
    r       lsUserFolders%rowtype;

BEGIN
    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
    
    IF NOT EXISTS(select * from lsUserFolders where (UserID = _userID AND lower(FolderName) = lower(_folderName))) THEN
        -- Create default folders
        IF lower(_folderName) = 'inbox' THEN
            insert into lsUserFolders (UserID,FolderID,FolderName)
            values (_userID,now(),'Inbox');
        END IF;
    END IF;
    
    FOR r IN (select * from lsUserFolders where (UserID = _userID AND lower(FolderName) = lower(_folderName))) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets domains.
*/
CREATE OR REPLACE FUNCTION lspr_GetDomains(
) RETURNS setof lsdomains

AS $$

DECLARE
    r lsdomains%rowtype;
        
BEGIN
    FOR r IN (select * from lsdomains) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets filters.
*/
CREATE OR REPLACE FUNCTION lspr_GetFilters(
) RETURNS setof lsFilters

AS $$

DECLARE
    r lsFilters%rowtype;

BEGIN
    FOR r IN (select * from lsFilters) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets specified folder ACL entries.
    _FolderOwnerUser - User who owns folder.
    _FolderName      - Folder path.
*/
CREATE OR REPLACE FUNCTION lspr_GetFolderACL(
    _folderOwnerUser varchar,
    _folderName      varchar
) RETURNS setof acl_entry

AS $$

DECLARE
    _entry    acl_entry;
    _userID   varchar;
    _folderID varchar;
    r         lsIMAP_ACL%rowtype;

BEGIN
    _userID   := (select UserID from lsUsers where (lower(UserName) = lower(_folderOwnerUser)));
    _folderID := (select FolderID from lsUserFolders where (UserID = _userID AND lower(FolderName) = lower(_folderName)));

    FOR r IN (select * from lsIMAP_ACL where (FolderID = _folderID)) LOOP
        IF EXISTS(select UserName from lsUsers where (UserID = r.UserOrGroupID)) THEN
            _entry.User := (select UserName from lsUsers where (UserID = r.UserOrGroupID));
        ELSIF EXISTS(select GroupName from lsGroups where (GroupID = r.UserOrGroupID)) THEN
            _entry.User := (select GroupName from lsGroups where (GroupID = r.UserOrGroupID));
        ELSE
            _entry.User := 'unknown_user_or_group';
        END IF;
        _entry.Permissions := r.Permissions;
            
        return next _entry;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets specified user folders.
    _userName - User whos folders to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetFolders(
    _userName varchar
) RETURNS setof lsUserFolders

AS $$

DECLARE
    _userID varchar;
    r       lsUserFolders%rowtype;

BEGIN
    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));

    FOR r IN (select * from lsUserFolders where (UserID = _userID)) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets specified global message rule actions.
    _ruleID - Rule ID which actions to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetGlobalMessageRuleActions(
    _ruleID varchar
) RETURNS setof lsGlobalMessageRuleActions

AS $$

DECLARE
    r lsGlobalMessageRuleActions%rowtype;

BEGIN
    FOR r IN (select * from lsGlobalMessageRuleActions where (RuleID = _ruleID)) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets global message rules.
*/
CREATE OR REPLACE FUNCTION lspr_GetGlobalMessageRules(
) RETURNS setof lsGlobalMessageRules

AS $$

DECLARE
    r lsGlobalMessageRules%rowtype;

BEGIN
    FOR r IN (select * from lsGlobalMessageRules ORDER BY Cost ASC) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets specified group members.
    _groupName - Group name which members to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetGroupMembers(
    _groupName varchar
) RETURNS setof varchar

AS $$

DECLARE
    _groupID varchar;
    r        lsGroupMembers%rowtype;

BEGIN
    _groupID := (select GroupID from lsGroups where (lower(GroupName) = lower(_groupName)));
    
    FOR r IN (select * from lsGroupMembers where (GroupID = _groupID)) LOOP
        -- See if user
        IF EXISTS(select UserName from lsUsers where (UserID = r.UserOrgroupID)) THEN
            return next (select UserName from lsUsers where (UserID = r.UserOrgroupID));
        -- See if group
        ELSIF EXISTS(select GroupName from lsGroups where (GroupID = r.UserOrgroupID)) THEN
            return next (select GroupName from lsGroups where (GroupID = r.UserOrgroupID));
        END IF;
    
        --return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets groups.
*/
CREATE OR REPLACE FUNCTION lspr_GetGroups(
) RETURNS setof lsGroups

AS $$

DECLARE
    r lsGroups%rowtype;

BEGIN
    FOR r IN (select * from lsGroups) LOOP
        return next r;	
    END LOOP;
    return;
END;

$$ LANGUAGE plpgsql;



/* Gets specified user mailbox size.
    _userName - User whos mailbox size to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetMailboxSize(
    _userName varchar
) RETURNS bigint

AS $$

DECLARE
    _userID varchar;
    r       lsMailingListACL%rowtype;

BEGIN
    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
    
    return ((select sum(Size) from lsMailStore where (UserID = _userID)));
END;

$$ LANGUAGE plpgsql;



/* Gets specified mailing list ACL entries.
    _mailingListName - Mailing list name which ACL entries to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetMailingListACL(
    _mailingListName varchar
) RETURNS setof varchar

AS $$

DECLARE
    _mailingListID varchar;
    _userOrGroupID varchar;
    _userOrGroup   varchar;
    r              lsMailingListACL%rowtype;

BEGIN
    -- Get mailing list ID
    _mailingListID := (select MailingListID from lsMailingLists where (lower(MailingListName) = lower(_mailingListName)));
    
    FOR r IN (select * from lsMailingListACL where (MailingListID = _mailingListID)) LOOP
        _userOrGroupID := r.UserOrGroupID;
        
        -- See if built-in user or group
	    IF _userOrGroupID = 'anyone' THEN
	        _userOrGroup := 'anyone';
        ELSIF _userOrGroupID = 'authenticated users' THEN
            _userOrGroup := 'authenticated users';
        -- See if user
        ELSIF EXISTS(select UserName from lsUsers where (UserID = _userOrGroupID)) THEN
            _userOrGroup := (select UserID from lsUsers where (UserID = _userOrGroupID));
        -- See if group
        ELSIF EXISTS(select GroupName from lsGroups where (GroupID = _userOrGroupID)) THEN
            _userOrGroup := (select GroupID from lsGroups where (GroupID = _userOrGroupID));
        END IF;
    
        return next _userOrGroup;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets specified mailing list members.
    _mailingListName - Mailing list name which members to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetMailingListAddresses(
    _mailingListName varchar
) RETURNS setof lsMailingListAddresses

AS $$

DECLARE
    _mailingListID varchar;
    r              lsMailingListAddresses%rowtype;

BEGIN
    IF _mailingListName != null THEN
	    _mailingListID = (select MailingListID from lsMailingLists where (lower(MailingListName) = lower(_mailingListName)));

	    FOR r IN (select * from lsMailingListAddresses where (MailingListID = _mailingListID)) LOOP
            return next r;	
        END LOOP;
    ELSE
        FOR r IN (select * from lsMailingListAddresses) LOOP
            return next r;	
        END LOOP;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Gets specified mailing list.
    _mailingListName - Mailing list name which to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetMailingListProperties(
    _mailingListName varchar
) RETURNS setof lsMailingLists

AS $$

DECLARE
    r lsMailingLists%rowtype;

BEGIN
    FOR r IN (select * from lsMailingLists where (lower(MailingListName) = lower(_mailingListName))) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets mailing lists.
*/
CREATE OR REPLACE FUNCTION lspr_GetMailingLists(
) RETURNS setof lsMailingLists

AS $$

DECLARE
    r lsMailingLists%rowtype;

BEGIN
    FOR r IN (select * from lsMailingLists) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets specified user message.
    _userName  - Folder owner user.
    _folder    - Folder name with path.
    _messageID - Message ID.
*/
CREATE OR REPLACE FUNCTION lspr_GetMessage(
    _userName  varchar,
    _folder    varchar,
    _messageID varchar
) RETURNS setof lsMailStore

AS $$

DECLARE
    _userID   varchar;
    _folderID varchar;
    errorText varchar;
    r         lsMailStore%rowtype;

BEGIN
    -- Get folder owner user ID
    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
    IF _userID = null THEN
        errorText := 'Invalid _userName ''' || _userName || ''', user doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
    END IF;
    
    -- Get folder ID
    _folderID := (select FolderID from lsUserFolders where (UserID = _userID AND lower(FolderName) = lower(_folder)));
    IF _userID = null THEN
        errorText := 'Invalid _folder ''' || _folder || ''', folder doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
    END IF;
    
    FOR r IN (select * from lsMailStore where (UserID = _userID AND FolderID = _folderID AND MessageID = _messageID)) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets specified user folder messages info.
    _userName - Folder owner user.
    _folder   - Folder name with path.
*/
CREATE OR REPLACE FUNCTION lspr_GetMessagesInfo(
    _userName varchar,
    _folder   varchar
) RETURNS setof messageinfo_entry

AS $$

DECLARE
    _userID   varchar;
    _folderID varchar;
    errorText varchar;
    r         messageinfo_entry%rowtype;

BEGIN
    -- Get folder owner user ID
    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
    IF _userID = null THEN
        errorText := 'Invalid _userName ''' || _userName || ''', user doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
    END IF;
    
    -- Get folder ID
    _folderID := (select FolderID from lsUserFolders where (UserID = _userID AND lower(FolderName) = lower(_folder)));
    IF _userID = null THEN
        errorText := 'Invalid _folder ''' || _folder || ''', folder doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
    END IF;

    FOR r IN (select MessageID,Size,Date,MessageFlags,UID from lsMailStore where (UserID = _userID AND FolderID = _folderID)) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets specified user folder message items.
    _userName  - Folder owner user.
    _folder    - Folder name with path.
    _messageID - Message ID.
*/
CREATE OR REPLACE FUNCTION lspr_GetMessagesItems(
    _userName  varchar,
    _folder    varchar,
    _messageID varchar
) RETURNS setof messageitem_entry

AS $$

DECLARE
    _userID   varchar;
    _folderID varchar;
    errorText varchar;
    r         messageitem_entry%rowtype;

BEGIN
    -- Get folder owner user ID
    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
    IF _userID = null THEN
        errorText := 'Invalid _userName ''' || _userName || ''', user doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
    END IF;

    -- Get folder ID
    _folderID := (select FolderID from lsUserFolders where (UserID = _userID AND lower(FolderName) = lower(_folder)));
    IF _userID = null THEN
        errorText := 'Invalid _folder ''' || _folder || ''', folder doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
    END IF;

    FOR r IN (select TopLines,ImapEnvelope,ImapBody from lsMailStore where (UserID = _userID AND FolderID = _folderID AND MessageID = _messageID)) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets POP3 message top lines.
    _userName  - Folder owner user.
    _folder    - Folder name with path.
    _messageID - Message ID.
*/
CREATE OR REPLACE FUNCTION lspr_GetMessageTopLines(
    _userName  varchar,
    _folder    varchar,
    _messageID varchar
) RETURNS bytea

AS $$

DECLARE
    _userID   varchar;
    _folderID varchar;
    errorText varchar;
    r         lsMailStore%rowtype;

BEGIN
    -- Get folder owner user ID
    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
    IF _userID = null THEN
        errorText := 'Invalid _userName ''' || _userName || ''', user doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
    END IF;

    -- Get folder ID
    _folderID := (select FolderID from lsUserFolders where (UserID = _userID AND lower(FolderName) = lower(_folder)));
    IF _userID = null THEN
        errorText := 'Invalid _folder ''' || _folder || ''', folder doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
    END IF;
    
    return (select TopLines from lsMailStore where (UserID = _userID AND FolderID = _folderID AND MessageID = _messageID));
END;

$$ LANGUAGE plpgsql;



/* Gets reycle bin message.
    _messageID - Recycle bin message ID.
*/
CREATE OR REPLACE FUNCTION lspr_GetRecycleBinMessage(
    _messageID varchar
) RETURNS setof lsRecycleBin

AS $$

DECLARE
    r lsRecycleBin%rowtype;

BEGIN
    FOR r IN (select * from lsRecycleBin where (MessageID = _messageID)) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets reycle bin messages info.
    _userName  - User who's recyclebin messages to get or null if all users messages.
    _startDate - Messages from specified date.
    _endDate   - Messages to specified date.
*/
CREATE OR REPLACE FUNCTION lspr_GetRecycleBinMessagesInfo(
    _userName  varchar,
    _startDate timestamp,
    _endDate   timestamp
) RETURNS setof recyclebinmessageinfo

AS $$

DECLARE
    r recyclebinmessageinfo%rowtype;

BEGIN
    IF _userName is null THEN
        FOR r IN (select MessageID,DeleteTime,"User",Folder,Size,Envelope from lsRecycleBin where(_startDate <= DeleteTime::date) AND _endDate >= DeleteTime::date) LOOP
            return next r;	
        END LOOP;
    ELSE
        FOR r IN (select MessageID,DeleteTime,"User",Folder,Size,Envelope from lsRecycleBin where("User" = lower(_userName) AND _startDate <= DeleteTime::date) AND _endDate >= DeleteTime::date) LOOP
            return next r;	
        END LOOP;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Gets reycle bin settings.
*/
CREATE OR REPLACE FUNCTION lspr_GetRecycleBinSettings(
) RETURNS setof lsRecycleBinSettings

AS $$

DECLARE
    r lsRecycleBinSettings%rowtype;

BEGIN
    FOR r IN (select * from lsRecycleBinSettings) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets routes.
*/
CREATE OR REPLACE FUNCTION lspr_GetRoutes(
) RETURNS setof lsRouting

AS $$

DECLARE
    r lsRouting%rowtype;

BEGIN
    FOR r IN (select * from lsRouting) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets IP security entries.
*/
CREATE OR REPLACE FUNCTION lspr_GetSecurityList(
) RETURNS setof lsIPSecurity

AS $$

DECLARE
    r lsIPSecurity%rowtype;

BEGIN
    FOR r IN (select * from lsIPSecurity) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets system settings.
*/
CREATE OR REPLACE FUNCTION lspr_GetSettings(
) RETURNS setof lsSettings

AS $$

DECLARE
    r lsSettings%rowtype;

BEGIN
    FOR r IN (select * from lsSettings) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets shared root folders.
*/
CREATE OR REPLACE FUNCTION lspr_GetSharedFolderRoots(
) RETURNS setof lsSharedFoldersRoots

AS $$

DECLARE
    r lsSharedFoldersRoots%rowtype;

BEGIN
    FOR r IN (select * from lsSharedFoldersRoots) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets user subscribed folders.
    _userName - User name which subscribed folders to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetSubscribedFolders(
    _userName varchar
) RETURNS setof lsIMAPSubscribedFolders

AS $$

DECLARE
    _userID varchar;
    r       lsIMAPSubscribedFolders%rowtype;

BEGIN
    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
    
    FOR r IN (select * from lsIMAPSubscribedFolders where (UserID = _userID)) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets specified user email addresses.
    _userName - User name whos email addresses to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetUserAddresses(
    _userName varchar
) RETURNS setof varchar

AS $$

DECLARE
    _userID varchar;
    r       record;

BEGIN
    IF _userName != '' THEN
 	    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
	
	    FOR r IN (
            select LocalPart || '@' || (
                select DomainName from lsDomains
                where (lsDomains.DomainID = lsEmailAddresses.DomainID)
            ) AS EmailAddress
            from lsEmailAddresses
            where (OwnerID = _userID)
        )
        LOOP
            return next r.EmailAddress;	
        END LOOP;
    ELSE
        FOR r IN (
            select LocalPart || '@' || (
                select DomainName from lsDomains
                where (lsDomains.DomainID = lsEmailAddresses.DomainID)
            ) AS EmailAddress
            from lsEmailAddresses
        )
        LOOP
            return next r.EmailAddress;	
        END LOOP;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Gets user message rule actions.
    _userID - Message rule owner user ID.
    _ruleID - Rule ID which actions to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetUserMessageRuleActions(
    _userID varchar,
    _ruleID varchar
) RETURNS setof lsUserMessageRuleActions

AS $$

DECLARE
    r lsUserMessageRuleActions%rowtype;

BEGIN
    FOR r IN (select * from lsUserMessageRuleActions where (UserID = _userID AND RuleID = _ruleID)) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets user message rules.
    _userName - User name which message rules to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetUserMessageRules(
    _userName varchar
) RETURNS setof lsUserMessageRules

AS $$

DECLARE
    _userID varchar;
    r       lsUserMessageRules%rowtype;

BEGIN
    IF _userName != '' THEN
 	    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
	
	    FOR r IN (select * from lsUserMessageRules where (UserID = _userID)) LOOP
            return next r;	
        END LOOP;
    ELSE
        FOR r IN (select * from lsUserMessageRules) LOOP
            return next r;	
        END LOOP;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Gets specified user.
    _userName - User name which settings to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetUserProperties(
    _userName varchar
) RETURNS setof lsUsers

AS $$

DECLARE
    r lsUsers%rowtype;

BEGIN
    FOR r IN (select * from lsUsers where (lower(UserName) = lower(_userName))) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets specified user remote servers.
    _userName - User name which remote servers to get.
*/
CREATE OR REPLACE FUNCTION lspr_GetUserRemoteServers(
    _userName varchar
) RETURNS setof lsUserRemoteServers

AS $$

DECLARE
    _userID varchar;
    r       lsUserRemoteServers%rowtype;

BEGIN
    IF _userName != '' THEN
        _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));

        FOR r IN (select * from lsUserRemoteServers where (UserID = _userID)) LOOP
            return next r;	
        END LOOP;
    ELSE
        FOR r IN (select * from lsUserRemoteServers) LOOP
            return next r;	
        END LOOP;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Gets users.
*/
CREATE OR REPLACE FUNCTION lspr_GetUsers(
) RETURNS setof lsUsers

AS $$

DECLARE
    r lsUsers%rowtype;

BEGIN
    FOR r IN (select * from lsUsers) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Gets users default folders.
*/
CREATE OR REPLACE FUNCTION lspr_GetUsersDefaultFolders(
) RETURNS setof lsUsersDefaultFolders

AS $$

DECLARE
    r lsUsersDefaultFolders%rowtype;

BEGIN
    FOR r IN (select * from lsUsersDefaultFolders) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Checks if specified group exists.
    _groupName - Group name which to check.
*/
CREATE OR REPLACE FUNCTION lspr_GroupExists(
    _groupName varchar
) RETURNS setof lsGroups

AS $$

DECLARE
    r lsGroups%rowtype;

BEGIN
    FOR r IN (select * from lsGroups where (lower(GroupName) = lower(_groupName))) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Checks if speciifed group member exists.
    _groupName   - Group name which member to check.
    _userOrGroup - USer or group name which to check.
*/
CREATE OR REPLACE FUNCTION lspr_GroupMemberExists(
    _groupName   varchar,
    _userOrGroup varchar
) RETURNS setof lsGroupMembers

AS $$

DECLARE
    _groupID varchar;
    r        lsGroupMembers%rowtype;

BEGIN
    _groupID := (select GroupID from lsGroups where (lower(GroupName) = lower(_groupName)));
    
    FOR r IN (select * from lsGroupMembers where (GroupID = _groupID AND UserOrGroup = _userOrGroup)) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Maps email address to user name.
    _localPart  - Email local part. localpart[@domain].
    _domainName - Email domain name.
*/
CREATE OR REPLACE FUNCTION lspr_MapUser(
    _localPart  varchar,
    _domainName varchar
) RETURNS setof lsUsers

AS $$

DECLARE
    _domainID varchar;
    _userID   varchar;
    r         lsUsers%rowtype;

BEGIN
    _domainID := (select DomainID from lsDomains where (lower(DomainName) = lower(_domainName)));
    _userID   := (select OwnerID from lsEmailAddresses where (lower(LocalPart) = lower(_localPart) AND DomainID = _domainID));
    
    FOR r IN (select * from lsUsers where (UserID = _userID)) LOOP
        return next r;	
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/* Renames specified user folder.
    _folderOwnerUser - Folder owner user.
    _folderName      - Folder name with path.
    _newFolderName   - New folder name with path.
*/
CREATE OR REPLACE FUNCTION lspr_RenameFolder(
    _folderOwnerUser varchar,
    _folderName      varchar,
    _newFolderName   varchar
) RETURNS setof lsUsers

AS $$

DECLARE
    _folderOwnerID varchar;
    _folderID      varchar;
    r              lsUserFolders%rowtype;
    errorText      varchar;

BEGIN
    _folderOwnerID := (select UserID from lsUsers where (lower(UserName) = lower(_folderOwnerUser)));
    _folderID      := (select FolderID from lsUserFolders where (UserID = _folderOwnerID AND lower(FolderName) = lower(_folderName)));

    -- Ensure that source folder exists
    IF _folderID = null THEN
        errorText := ('Invalid source folder, ' || _folderName || ' doesn''t exist');
        RAISE EXCEPTION '%',errorText;
    END IF;
    
    -- Ensure that destinaton folder doesn't exist
    IF EXISTS (select FolderID from lsUserFolders where (UserID = _folderOwnerID AND lower(FolderName) = lower(_newFolderName))) THEN
       errorText := ('Invalid destination folder, ' || _newFolderName || ' already exist');
       RAISE EXCEPTION '%',errorText;
    END IF;

    -- Loop folder and it's child folders
    FOR r IN (select * from lsUserFolders where (UserID = _folderOwnerID AND lower(FolderName) = lower(_folderName) OR lower(FolderName) LIKE lower(_folderName || '/%'))) LOOP
        update lsUserFolders set
            FolderName =_newFolderName || substring(FolderName from (length(_folderName) + 1))
        where (UserID = _folderOwnerID AND FolderID = r.FolderID);
    END LOOP;
END;

$$ LANGUAGE plpgsql;



/*
    _folderOwnerUser - User that owns specified folder.
    _folderName      - Folder full path. For example Inbox/subFolder.
    _userOrGroup     - User or group whos permissions to set.
    _permissions     - User or Group permissions on the specified folder.
*/
CREATE OR REPLACE FUNCTION lspr_SetFolderACL(
    _folderOwnerUser varchar,
    _folderName      varchar,
    _userOrGroup     varchar,
    _permissions     varchar
) RETURNS void

AS $$

DECLARE
    _folderOwnerID varchar;
    _folderID      varchar;
    _userOrGroupID varchar;
    errorText      varchar;

BEGIN
    _folderOwnerID := (select UserID from lsUsers where (lower(UserName) = lower(_folderOwnerUser)));
    _folderID      := (select FolderID from lsUserFolders where (UserID = _folderOwnerID AND FolderName = _folderName));

    -- Handle built-in user anyone
    IF lower(_userOrGroup) = 'anyone' THEN
        _userOrGroupID := _userOrGroup;
    ELSE
        -- See if user
        IF EXISTS(select UserID from lsUsers where (lower(UserName) = lower(_userOrGroup))) THEN
            _userOrGroupID := (select UserID from lsUsers where (lower(UserName) = lower(_userOrGroup)));
        -- See if group
        ELSIF EXISTS(select GroupID from lsGroups where (lower(GroupName) = lower(_userOrGroup))) THEN
            _userOrGroupID := (select GroupID from lsGroups where (lower(GroupName) = lower(_userOrGroup)));
        -- Error
        ELSE
            errorText := ('Invalid user or group, ' || _userOrGroup || ' doesn''t exist');
		    RAISE EXCEPTION '%',errorText;
        END IF;
    END IF;

    IF EXISTS(select * from lsIMAP_ACL where (FolderOwnerUserID = _folderOwnerID AND FolderID = _folderID)) THEN
        update lsIMAP_ACL set
            UserOrGroupID = _userOrGroupID,
            Permissions   = _permissions
        where (FolderOwnerUserID = _folderOwnerID AND FolderID = _folderID);
    ELSE
        insert into lsIMAP_ACL (FolderOwnerUserID,FolderID,UserOrGroupID,Permissions)
        values (_folderOwnerID,_folderID,_userOrGroupID,_permissions);
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Stores specified message to specified user folder.
    _userName  - Folder owner user.
    _folder    - Folder name with path.
    _messageID - Message ID.
    _size      - Message size in bytes.
    _date      - Message internal data.
    _topLines  - Message top lines for POP3 TOP command.
    _data      - Message data.
*/
CREATE OR REPLACE FUNCTION lspr_StoreMessage(
    _userName     varchar,
    _folder       varchar,
    _messageID    varchar,
    _size         integer,
    _messageFlags integer,
    _date         timestamp,
    _topLines     bytea,
    _data         bytea,
    _imapEnvelope bytea,
    _imapBody     bytea
) RETURNS void

AS $$

DECLARE
   _userID   varchar;
   _folderID varchar;
   _uidNext  bigint;
   errorText varchar;

BEGIN
    _userID   := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
    _folderID := (select FolderID from lsUserFolders where (UserID = _userID AND lower(FolderName) = lower(_folder)));

    IF _folderID = null THEN
        errorText := ('Folder ' || _folder || ' doesn''t exist');
		RAISE EXCEPTION '%',errorText;
    END IF;
    
    -- Get Message UID and also increase UIDNEXT value by 1
    lock lsUserFolders in EXCLUSIVE mode;
    _uidNext := (select MessageUidNext from lsUserFolders where (FolderID = _folderID));
    update lsUserFolders set
        MessageUidNext = (_uidNext + 1)
    where (FolderID = _folderID);

    insert into lsMailStore (
        UserID,
        FolderID,
        MessageID,
        Size,
        MessageFlags,
        Date,
        TopLines,
        Data,
        ImapEnvelope,
        ImapBody,
        UID
    )
    values (
        _userID,
        _folderID,
        _messageID,
        _size,
        _messageFlags,
        _date,
        _topLines,
        _data,
        _imapEnvelope,
        _imapBody,
        _uidNext
    );
END;

$$ LANGUAGE plpgsql;



/* Stores specifed user message flags.
    _userName     - Folder owner user.
    _folder       - Folder name with path.
    _messageID    - Message ID.
    _messageFlags - Message flags.
*/
CREATE OR REPLACE FUNCTION lspr_StoreMessageFlags(
    _userName     varchar,
    _folder       varchar,
    _messageID    varchar,
    _messageFlags integer
) RETURNS void

AS $$

DECLARE
   _userID   varchar;
   _folderID varchar;
   errorText varchar;

BEGIN
    _userID   := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
    _folderID := (select FolderID from lsUserFolders where (UserID = _userID AND lower(FolderName) = lower(_folder)));

    update lsMailStore set
        MessageFlags = _messageFlags
    where (UserID = _UserID AND FolderID = _folderID AND MessageID = _messageID);
END;

$$ LANGUAGE plpgsql;



/* Stores specified message to recycel bin.
    _messageID - Recycle bin message ID.
    _user      - User whos messge it is.
    _folder    - Original folder that contained message.
    _size      - Message size in bytes.
    _envelope  - Message IMAP Envelop string.
    _data      - Message data.
*/
CREATE OR REPLACE FUNCTION lspr_StoreRecycleBinMessage(
    _messageID varchar,
    _user      varchar,
    _folder    varchar,
    _size      bigint,
    _envelope  varchar,
    _data      bytea
) RETURNS void

AS $$

BEGIN
    insert into lsRecycleBin (MessageID,DeleteTime,"User",Folder,Size,Envelope,Data)
        values(_messageID,now(),_user,_folder,_size,_envelope,_data);
END;

$$ LANGUAGE plpgsql;



/* Subscribes specified user folder.
    _userName - User name which folder to subscribe.
    _folder   - folder name with path which to subscribe.
*/
CREATE OR REPLACE FUNCTION lspr_SubscribeFolder(
    _userName varchar,
    _folder   varchar
) RETURNS void

AS $$

DECLARE
   _userID   varchar;
   errorText varchar;

BEGIN
    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));

    insert into lsIMAPSubscribedFolders (UserID,FolderName) values (_userID,_folder);
END;

$$ LANGUAGE plpgsql;



/* Unsubscribes specified user folder.
    _userName - User name which folder to unsubscribe.
    _folder   - Folder name with path which to unsubscribe.
*/
CREATE OR REPLACE FUNCTION lspr_UnSubscribeFolder(
    _userName varchar,
    _folder   varchar
) RETURNS void

AS $$

DECLARE
   _userID   varchar;
   errorText varchar;

BEGIN
    _userID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));

    delete from lsIMAPSubscribedFolders where (UserID = _userID AND lower(FolderName) = lower(_folder));
END;

$$ LANGUAGE plpgsql;



/* Updates domain.
    _domainID    - Domain ID which to update.
    _domainName  - Domain name.
    _description - Domain description.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateDomain(
    _domainID    varchar,
    _domainName  varchar,
    _description varchar
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    -- Ensure that domain with specified ID exists
    IF NOT EXISTS(select * from lsDomains where (DomainID = _domainID)) THEN
        errorText := 'Domain with specified ID "' || _domainID || '" doesn''t exists !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
    
    -- Ensure that another domain haven't same domain name
    IF EXISTS(select * from lsDomains where (DomainID != _domainID AND DomainName = _domainName)) THEN
        errorText := 'Domain with specified name "' || _domainName || '" already exists !';
	    RAISE EXCEPTION '%',errorText;
    END IF;

    update lsDomains set
        DomainName  = _domainName,
        Description = _description
    where (DomainID = _domainID);
END;

$$ LANGUAGE plpgsql;



/* Updates specified filter.
    _filterID    - Filter ID which to update.
    _description - Filter description.
    _type        - Filter type.
    _assembly    - Filter assembly.
    _className   - Filter class name.
    _cost        - Filter cost. Lower values are prcessed first.
    _enabled     - Specifies if filter is enabled.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateFilter(
    _filterID    varchar,
    _description varchar,
    _type        varchar,
    _assembly    varchar,
    _className   varchar,
    _cost        bigint ,
    _enabled     boolean
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF EXISTS(select * from lsFilters where (FilterID = _filterID)) THEN
	    update lsFilters set
		    Description = _description,
		    Type        = _type,
		    Assembly    = _assembly,
	        ClassName   = _className,
		    Cost        = _cost,
		    Enabled     = _enabled
	    where  (FilterID = _filterID);
    ELSE
        select 'Filter with specified ID "' || _filterID || '" doesn''t exist !';
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Updates specified global message rule.
    _ruleID          - Rule ID which to update.
    _cost            - Rule cost. Lower values are processed first.
    _enabled         - Specifies if global message rule is enabled.
    _checkNextRule   - Specifies when next rule is checked.
    _description     - Global message rule description.
    _matchExpression - Match expression.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateGlobalMessageRule(
    _ruleID          varchar,
	_cost            bigint ,
	_enabled         boolean,
	_checkNextRule   integer,
	_description     varchar,
	_matchExpression bytea
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF EXISTS(select * from lsGlobalMessageRules where (RuleID = _ruleID)) THEN
		update lsGlobalMessageRules set
			RuleID          = _ruleID,
			Cost            = _cost,
			Enabled         = _enabled,
			CheckNextRuleIf = _checkNextRule,
			Description     = _description,
			MatchExpression = _matchExpression
		where  (RuleID = _ruleID);
    ELSE
		errorText := 'Rule with specified ID "' || _ruleID || '" doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
	END IF;
END;

$$ LANGUAGE plpgsql;



/* Updates specified global message rule action.
    _ruleID      - Action owner global message rule.
    _actionID    - Action ID which to update.
    _description - Action description.
    _actionType  - Action type.
    _actionData  - Action data.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateGlobalMessageRuleAction(
    _ruleID      varchar,
	_actionID    varchar,
	_description varchar,
	_actionType  integer,
	_actionData  bytea
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF EXISTS(select * from lsGlobalMessageRuleActions where (RuleID = _ruleID AND ActionID = _ActionID)) THEN
    	update lsGlobalMessageRuleActions set
			RuleID      = _ruleID,
			ActionID    = _actionID,
			Description = _description,
			ActionType  = _actionType,
			ActionData  = _actionData
		where  (RuleID = _ruleID AND ActionID = _ActionID);
    ELSE
		errorText := 'Action with specified ID "' || _actionID || '" doesn''t exist !';
		RAISE EXCEPTION '%',errorText;
	END IF;
END;

$$ LANGUAGE plpgsql;



/* Updates specified group.
    _groupID     - Group ID which to update.
    _groupName   - Group name.
    _description - Group description.
    _enabled     - Specifies if group is enabled.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateGroup(
    _groupID     varchar,
	_groupName   varchar,
	_description varchar,
	_enabled     boolean
) RETURNS void

AS $$

DECLARE
   _currentGroupName varchar;
   errorText         varchar;

BEGIN
    -- Ensure that group with specified ID does exist.
	IF NOT EXISTS(select * from lsGroups where (GroupID = _groupID)) THEN
		errorText := 'Invalid group ID, specified group ID ''' || _groupID || ''' already exists !';
		RAISE EXCEPTION '%',errorText;
	END IF;

	-- If group name is changed, ensure that new group name won't conflict
    -- any other group or user name. Throw Exception if does.
	_currentGroupName := (select GroupName from lsGroups where (GroupID = _groupID));
	IF _currentGroupName != _groupName THEN
		-- Ensure that group name won't exist already.
		IF EXISTS(select * from lsGroups where (lower(GroupName) = lower(_groupName))) THEN
			errorText := 'Invalid group name, specified group ''' || _groupName || ''' already exists !';
			RAISE EXCEPTION '%',errorText;
		-- Ensure that user name with groupName doen't exist.
		ELSIF EXISTS(select * from lsUsers where (lower(UserName) = lower(_groupName))) THEN
			errorText := 'Invalid group name, user with specified name ''' || _groupName || ''' already exists !';
			RAISE EXCEPTION '%',errorText;
		END IF;
	END IF;

	-- Insert group
	update lsGroups set
		GroupID     = _groupID,
		GroupName   = _groupName,
		Description = _description,
		Enabled     = _enabled	
	where (GroupID = _groupID);
END;

$$ LANGUAGE plpgsql;



/* Updates specified mailing list.
    _mailingListID   - Mailing list ID which to update.
    _mailingListName - Mailing list name.
    _description     - Mailing list name.
    _domainName      - Not used. FIX ME:
    _enabled         - Specifies if mailing list is enabled.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateMailingList(
    _mailingListID	 varchar,
    _mailingListName varchar,
    _description     varchar,
    _domainName      varchar,
    _enabled         boolean
) RETURNS void

AS $$

DECLARE
   _mailingListOwnerID varchar;
   errorText           varchar;

BEGIN
    IF EXISTS(select * from lsMailingLists where (MailingListID = _mailingListID)) THEN
	    -- If changeing mailing list name, ensure that anyone already haven't got it
	    IF EXISTS(select * from lsMailingLists where (lower(MailingListName) = lower(_mailingListName))) THEN	
		    _mailingListOwnerID := (select MailingListID from lsMailingLists where (lower(MailingListName) = lower(_mailingListName)));
		    if _mailingListOwnerID != _mailingListID THEN
			    errorText := 'Mailing list with name "' || _mailingListName || '" already exists !';
			    RAISE EXCEPTION '%',errorText;
		    END IF;
	    END IF;

	    update lsMailingLists set
		    MailingListName = _mailingListName,
		    Description     = _description,
		    DomainName      = _domainName,
		    Enabled         = _enabled
        where  (MailingListID = _mailingListID);
    ELSE
	    errorText := 'Mailing list with specified ID "' || _mailingListID || '" doesn''t exist !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Updates recycle bin settings.
    _deleteToRecycleBin  - Specifies if messages are deleted to recycle bin.
    _deleteMessagesAfter - Specifies after what days messages will be deleted.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateRecycleBinSettings(
    _deleteToRecycleBin  boolean,
	_deleteMessagesAfter integer
) RETURNS void

AS $$

DECLARE

BEGIN
    IF EXISTS(select * from lsRecycleBinSettings) THEN
	    update lsRecycleBinSettings set
            DeleteToRecycleBin  = _deleteToRecycleBin,
            DeleteMessagesAfter = _deleteMessagesAfter;
    ELSE
        insert into lsRecycleBinSettings (DeleteToRecycleBin,DeleteMessagesAfter)
            values (_deleteToRecycleBin,_deleteMessagesAfter);
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Updates specified route.
    _routeID     - Route ID which to update.
    _cost        - Route cost. Lower values are processed first.
    _enabled     - Specifies if route is enabled.
    _description - Route description.
    _pattern     - Route match pattern.
    _action      - Route action.
    _actionData  - Route action data.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateRoute(
    _routeID     varchar,
	_cost        bigint ,
	_enabled     boolean,
	_description varchar,
	_pattern     varchar,
	_action      integer,
	_actionData  bytea
) RETURNS void

AS $$

DECLARE
   _routeOwnerID varchar;
   errorText     varchar;

BEGIN
    IF EXISTS(select * from lsRouting where (RouteID = _routeID)) THEN
	    -- If changeing route pattern, ensure that it  doesn't exist already
	    IF EXISTS(select * from lsRouting where (lower(Pattern) = lower(_pattern))) THEN
		    _routeOwnerID := (select RouteID from lsRouting where (lower(Pattern) = lower(_pattern)));
		    IF _routeOwnerID != _routeID THEN
			    errorText := 'Route with pattern "' || _pattern || '" already exists !';
			    RAISE EXCEPTION '%',errorText;
		    END IF;
	    END IF;

	    update lsRouting set
		    Cost        = _cost,
		    Enabled     = _enabled,
		    Description = _description,
		    Pattern     = _pattern,
		    Action      = _action,
		    ActionData  = _actionData
	    where  (RouteID = _routeID);
    ELSE
	    errorText := 'Route with specified ID "' || _routeID || '" doesn''t exist !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Updates specified IP security entry.
    _id          - IP security entry ID which to update.
    _enabled     - Specifies if IP security entry is enabled.
    _description - IP security entry description.
    _service     - Service type.
    _action      - Action.
    _startIP     - Range start IP address.
    _endIP       - Range end IP address.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateSecurityEntry(
    _id          varchar,
    _enabled     boolean,
    _description varchar,
    _service     integer,
    _action      integer,
    _startIP     varchar,
    _endIP       varchar
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF EXISTS(select * from lsIPSecurity where (ID = _id)) THEN
	    update lsIPSecurity set
		    Enabled     = _enabled,
		    Description = _description,
		    Service     = _service,
		    Action      = _action,
		    StartIP     = _startIP,
		    EndIP       = _endIP
	    where (ID = _id);
    ELSE
	    errorText := 'Security entry with specified ID "' || _id || '" doesn''t exist !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Updates system settings.
    _settings - Settings data.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateSettings(
    _settings bytea
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF EXISTS(select * from lsSettings) THEN
	    update lsSettings set
		    Settings = _settings;
    ELSE
	    insert into lsSettings (Settings) values (_settings);
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Updates specified shared root folder.
    _rootID        - Shared root folder ID which to update.
    _enabled       - Specifies if shared root folder is enabled.
    _folder        - Shared root folder name.
    _description   - Shared root folder description.
    _rootType      - Shared root folder type.
    _boundedUser   - Shared root folder bounded user.
    _boundedFolder - Shared root folder bounded user folder.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateSharedFolderRoot(
    _rootID        varchar,
	_enabled       boolean,
	_folder        varchar,
	_description   varchar,
	_rootType      integer,
	_boundedUser   varchar,
	_boundedFolder varchar
) RETURNS void

AS $$

DECLARE
   _currentRootName varchar;
   errorText        varchar;

BEGIN
    -- Ensure that root with specified ID does exist.
	IF NOT EXISTS(select * from lsSharedFoldersRoots where (RootID = _rootID)) THEN
		errorText := 'Invalid root ID, specified root ID ''' || _rootID || ''' already exists !';
		RAISE EXCEPTION '%',errorText;
	END IF;

	-- If root name is changed, ensure that new root name won't conflict
    -- any other root name. Throw Exception if does.
	_currentRootName := (select Folder from lsSharedFoldersRoots where (RootID = _rootID));
	IF _currentRootName != _folder THEN
		-- Ensure that root name won't exist already.
		IF exists(select * from lsSharedFoldersRoots where (lower(Folder) = lower(_folder))) THEN
			errorText := 'Invalid root name, specified root ''' || _folder || ''' already exists !';
			RAISE EXCEPTION '%',errorText;
		END IF;
	END IF;
	
	update lsSharedFoldersRoots set
		Enabled       = _enabled,
		Folder        = _folder,
		Description   = _description,
		RootType      = _rootType,
		BoundedUser   = _boundedUser,
		BoundedFolder = _boundedFolder
	where (RootID = _rootID);
END;

$$ LANGUAGE plpgsql;



/* Updates specified user.
    _userID      - User ID which to update.
    _fullName    - User full name.
    _userName    - User login name.
    _password    - User password.
    _description - User description.
    _domainName  - Not used. FIX ME:
    _mailboxSize - ser maximum malibox size.
    _enabled     - Specifies if user is enabled.
    _permissions - User permissions.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateUser(
    _userID	     varchar,
    _fullName    varchar,
    _userName    varchar,
    _password    varchar,
    _description varchar,
    _domainName  varchar,
    _mailboxSize integer,
    _enabled     boolean,
    _permissions integer
) RETURNS void

AS $$

DECLARE
   userNameOwnerID varchar;
   errorText       varchar;

BEGIN
    IF EXISTS(select * from lsUsers where (UserID = _userID)) THEN
	    -- If changing username, ensure that anyone already haven't got it
        IF EXISTS(select * from lsUsers where (lower(UserName) = lower(_userName))) THEN
            userNameOwnerID := (select UserID from lsUsers where (lower(UserName) = lower(_userName)));
		    IF userNameOwnerID != _userID THEN
			    errorText := 'User with user name "' || _userName || '" already exists !';			
	            RAISE EXCEPTION '%',errorText;
            END IF;
	    END IF;

	    update lsUsers set
		    FullName      = _fullName,
            UserName      = _userName,
            Password      = _password,
            Description   = _description,
            Mailbox_Size  = _mailboxSize,
            DomainName    = _domainName,
            Enabled       = _enabled,
            Permissions   = _permissions
            where  (UserID = _userID);
    ELSE
	    errorText := 'User with specified ID "' || _userID || '" doesn''t exist !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Updates user last lgoin time.
    _userName - User name whos last login time to update.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateUserLastLoginTime(
    _userName varchar
) RETURNS void

AS $$

DECLARE
   --errorText varchar;

BEGIN
    update lsUsers set
        LastLoginTime = now()
    where (lower(UserName) = lower(_userName));
END;

$$ LANGUAGE plpgsql;



/* Updates specified user message rule.
    _userID          - User message rule owner user.
    _ruleID          - Rule ID which to update.
    _cost            - Rule cost. Lower values are processed first.
    _enabled         - Specifies if user message rule is enabled.
    _checkNextRule   - Specifies when next rule is checked.
    _description     - User message rule desription.
    _matchExpression - Match expression.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateUserMessageRule(
    _userID          varchar,
	_ruleID          varchar,
	_cost            bigint ,
	_enabled         boolean,
	_checkNextRule   integer,
	_description     varchar,
	_matchExpression bytea
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF EXISTS(select * from lsUserMessageRules where (UserID = _userID AND RuleID = _ruleID)) THEN
		update lsUserMessageRules set
			UserID          = _userID,
			RuleID          = _ruleID,
			Cost            = _cost,
			Enabled         = _enabled,
			CheckNextRuleIf = _checkNextRule,
			Description     = _description,
			MatchExpression = _matchExpression
		where (UserID = _userID AND RuleID = _ruleID);
	ELSE
		select 'Rule with specified ID "' || _ruleID || '" doesn''t exist !';
	END IF;
END;

$$ LANGUAGE plpgsql;



/* Updates specified user message rule action.
    _userID     - Message rule owner user.
    _ruleID     - Action owner rule ID.
    _actionID   - Action ID which to update.
    _actionType - Action type.
    _actionData - Action data.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateUserMessageRuleAction(
    _userID      varchar,
	_ruleID      varchar,
	_actionID    varchar,
	_description varchar,
	_actionType  integer,
	_actionData  bytea
) RETURNS void

AS $$

DECLARE
   errorText varchar;

BEGIN
    IF EXISTS(select * from lsUserMessageRuleActions where (UserID = _userID AND RuleID = _ruleID AND ActionID = _actionID)) THEN
        update lsUserMessageRuleActions set
			UserID      = _userID,
			RuleID      = _ruleID,
			ActionID    = _actionID,
			Description = _description,
			ActionType  = _actionType,
			ActionData  = _actionData
		where (UserID = _userID AND RuleID = _ruleID AND ActionID = _actionID);
    ELSE
		errorText := 'Action with specified ID "' || _actionID || '" doesn''t exist !';
	    RAISE EXCEPTION '%',errorText;
	END IF;
END;

$$ LANGUAGE plpgsql;



/* Updates specified user remote server.
    _serverID       - Remote server ID which to update.
    _userName       - User name whos remote server to update.
    _description    - Remote server description.
    _remoteServer   - Remote server host name or IP.
    _remotePort     - Remote server port.
    _remoteUserName - Remote server user name.
    _remotePassword - Remote server password.
    _useSSL         - Specifies if SSL must used to connect to remote server.
    _enabled        - Specifies if remote server is enabled.
*/
CREATE OR REPLACE FUNCTION lspr_UpdateUserRemoteServer(
    _serverID       varchar,
	_userName       varchar,
	_description    varchar,
	_remoteServer   varchar,
	_remotePort     integer,
	_remoteUserName varchar,
	_remotePassword varchar,
	_useSSL         boolean,
	_enabled        boolean
) RETURNS void

AS $$

DECLARE
   _userID   varchar;
   errorText varchar;

BEGIN
    IF exists(select * from lsUserRemoteServers where (ServerID = _serverID)) THEN
	    _userID = (select UserID from lsUsers where lower(UserName) = lower(_userName));

	    update lsUserRemoteServers set
		    ServerID       = _serverID,
		    UserID         = _userID,
		    Description    = _description,
		    RemoteServer   = _remoteServer,
		    RemotePort     = _remotePort,
		    RemoteUserName = _remoteUserName,
		    RemotePassword = _remotePassword,
		    UseSSL         = _useSSL,
		    Enabled        = _enabled
         where (ServerID = _serverID);
    ELSE
	    errorText := 'User remote server with specified ID "' || _serverID || '" doesn''t exist !';
	    RAISE EXCEPTION '%',errorText;
    END IF;
END;

$$ LANGUAGE plpgsql;



/* Validates user mail box size.
    _userName - User name which mailbox to validate.
        
   Returns: Returns true if mailbox size is exceeded.
*/
CREATE OR REPLACE FUNCTION lspr_ValidateMailboxSize(
    _userName varchar
) RETURNS boolean

AS $$

DECLARE
   _userID         varchar;
   _maxAllowedSize bigint;
   _mailboxSize    bigint;
   errorText       varchar;

BEGIN
    _userID         = (select UserID from lsUsers where lower(UserName) = lower(_userName));
    _maxAllowedSize = (select Mailbox_Size from lsUsers where lower(UserName) = lower(_userName)) * 1000;
    -- Unlimited mailbox size, don't calculate size.
    IF _maxAllowedSize < 1 THEN
        return false;
    END IF;
    _mailboxSize = (select count(Size) from lsMailStore where (UserID = _userID));
    
    IF _mailboxSize > _maxAllowedSize THEN
        return true;
    ELSE
        return false;
    END IF;
END;

$$ LANGUAGE plpgsql;

