USE [Ecommerce]
GO
/****** Object:  StoredProcedure [dbo].[SP_MANAGE_USER]    Script Date: 2017-06-01 5:43:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_MANAGE_USER]
@action varchar(50),
@UserId numeric(18,0)=0,
@UserTypeId int=0,
@Password nvarchar(MAX)='',
@FirstName nvarchar(100)='',
@LastName nvarchar(100)='',
@IsActive int=0,
@EmailId nvarchar(MAX)='',
@ContactNo nvarchar(50)='',
@Gender nvarchar(10)='',
@Birthdate date=null,
@requestedby nvarchar(10)=''
AS
BEGIN
	IF @action = 'INSERT'
	BEGIN
	INSERT INTO TblUser(UserTypeId,[Password],FirstName,LastName,IsActive,EmailId,ContactNo,Gender,Birthdate,Age,InsertedBy,InsertedOn,UpdatedOn,UpdatedBy) 
	VALUES (@UserTypeId,@Password,@FirstName,@LastName,@IsActive,@EmailId,@ContactNo,@Gender,@Birthdate,DATEDIFF(YY,@birthdate,getdate()),@requestedby,GETDATE(),@requestedby,GETDATE());

	SELECT @@IDENTITY;
	END
	ELSE IF @action = 'UPDATE'
	BEGIN
	UPDATE  TblUser
	SET UserTypeId=@UserTypeId,
		FirstName=@FirstName,LastName=@LastName,
		EmailId=@EmailId,ContactNo=@ContactNo,Gender=@Gender,
		Birthdate=@Birthdate,Age=DATEDIFF(YY,@birthdate,getdate()),
		UpdatedOn=getdate(),UpdatedBy=@requestedby 
	WHERE UserId = @UserId;

	SELECT @UserId;
	END
	ELSE IF @action = 'DELETE'
	BEGIN
		DELETE FROM TblUserAddress where UserId=@UserId;
		DELETE FROM TblUser WHERE UserId = @UserId;
	END
	ELSE IF @action='GETALL'
	BEGIN
		SELECT UserId,FirstName,IsActive, LastName,IsActive,EmailId,ContactNo,Gender,Birthdate,Age,U.InsertedBy,U.InsertedOn,U.UpdatedOn,U.UpdatedBy,UT.UserTypeId,UT.UserTypeName
		from TblUser U with(nolock)
		inner join TblUserType UT on UT.UserTypeId=U.UserTypeId
	END
	ELSE IF @action='GETBYID'
	BEGIN
		SELECT UserId,FirstName,IsActive, LastName,IsActive,EmailId,ContactNo,Gender,Birthdate,Age,U.InsertedBy,U.InsertedOn,U.UpdatedOn,U.UpdatedBy,UT.UserTypeId,UT.UserTypeName
		from TblUser U with(nolock)
		inner join TblUserType UT on UT.UserTypeId=U.UserTypeId
		where UserId=@UserId
	END
	Else IF @action='LOGIN'
	BEGIN
		SELECT UserId,FirstName,IsActive, LastName,IsActive,EmailId,ContactNo,Gender,Birthdate,Age,U.InsertedBy,U.InsertedOn,U.UpdatedOn,U.UpdatedBy,UT.UserTypeId,UT.UserTypeName
		from TblUser U with(nolock)
		inner join TblUserType UT on UT.UserTypeId=U.UserTypeId
		where EmailId=@EmailId and Password=@Password

	END
	else if @action='CHANGEPWD'
	BEGIN
		UPDATE TblUser set [Password]=@Password where UserId = @UserId;

		SELECT @UserId;
	END
END