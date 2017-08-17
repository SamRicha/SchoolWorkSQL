/*
surveysez-20170424.sql - updated 4/24/2017
*/

SET foreign_key_checks = 0; #turn off constraints temporarily

#since constraints cause problems, drop tables first, working backward
DROP TABLE IF EXISTS sp17_questions;
DROP TABLE IF EXISTS sp17_surveys;
DROP TABLE IF EXISTS sp17_authors;
  
#all tables must be of type InnoDB to do transactions, foreign key constraints
CREATE TABLE sp17_surveys(
SurveyID INT UNSIGNED NOT NULL AUTO_INCREMENT,
AuthorID INT UNSIGNED DEFAULT 0,
AdminID INT UNSIGNED DEFAULT 0,
Title VARCHAR(255) DEFAULT '',
Description TEXT DEFAULT '',
DateAdded DATETIME,
LastUpdated TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (SurveyID),
FOREIGN KEY (AuthorID) REFERENCES sp17_authors(AuthorID) ON DELETE CASCADE
)ENGINE=INNODB; 

#assigning first survey to AdminID == 1
INSERT INTO sp17_surveys VALUES (NULL,NULL,1,'Our First Survey','Description of Survey',NOW(),NOW()); 

#foreign key field must match size and type, hence SurveyID is INT UNSIGNED
CREATE TABLE sp17_questions(
QuestionID INT UNSIGNED NOT NULL AUTO_INCREMENT,
SurveyID INT UNSIGNED DEFAULT 0,
AuthorID INT UNSIGNED DEFAULT 0,
Question TEXT DEFAULT '',
Description TEXT DEFAULT '',
DateAdded DATETIME,
LastUpdated TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (QuestionID),
INDEX SurveyID_index(SurveyID),
FOREIGN KEY (SurveyID) REFERENCES sp17_surveys(SurveyID) ON DELETE CASCADE,
FOREIGN KEY (AuthorID) REFERENCES sp17_authors(AuthorID) ON DELETE CASCADE
)ENGINE=INNODB;

INSERT INTO sp17_questions VALUES (NULL,1,NULL,'Do You Like Our Website?','We really want to know!',NOW(),NOW());
INSERT INTO sp17_questions VALUES (NULL,1,NULL,'Do You Like Cookies?','We like cookies!',NOW(),NOW());
INSERT INTO sp17_questions VALUES (NULL,1,NULL,'Favorite Toppings?','We like chocolate!',NOW(),NOW());


#Add additional tables here
CREATE TABLE sp17_authors(
AuthorID INT UNSIGNED NOT NULL AUTO_INCREMENT,
AuthorLastname TEXT DEFAULT '',
AuthorFirstname TEXT DEFAULT '',
Company TEXT DEFAULT '',
HireDate DATE,
PRIMARY KEY (AuthorID))ENGINE=INNODB;

INSERT INTO sp17_authors VALUES (NULL,'Peters','Johns','Sony','2015-12-17');

SET foreign_key_checks = 1; #turn foreign key check back on
