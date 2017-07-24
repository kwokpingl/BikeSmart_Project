# -*- coding: utf-8 -*-
import mysql.connector
from mysql.connector import errorcode
import MySQLdb

class TBManager:
    def __init__(self, DB_NAME, USER, PWD, HOST):
        self.DB_NAME    = DB_NAME
        self.USER       = USER
        self.PWD        = PWD
        self.HOST       = HOST
        self.TABLES     = {}
        self.TBNames    = []
    
    def setTBNameArr (self, TBNames):
        self.TBNames = TBNames
    
    # Create Tables with Given Statement
    def createTBsWithStatement(self,statement):
        for table in self.TBNames:
            self.TABLES[table] = "CREATE TABLE " + table + \
            "(" + statement + ");"
            
        cnx = mysql.connector.connect(user = self.USER,
                                         password = self.PWD,
                                         database = self.DB_NAME)
        cursor = cnx.cursor()
        
        for name, ddl in self.TABLES.iteritems():
            try:
                cursor.execute(ddl)
            except mysql.connector.Error as err:
                if err.errno == errorcode.ER_TABLE_EXISTS_ERROR:
                    print(name + ' ALREADY EXISTS')
                else:
                    print(err.msg)
            else:
                print("OK")
        cursor.close()
        cnx.close()
    
    def doThis(self, data, values):
        cnx = mysql.connector.connect(user = self.USER,
                                      password = self.PWD,
                                      database = self.DB_NAME)
        cursor = cnx.cursor()
        cursor.execute(data, values)
        cnx.commit()
        cursor.close()
        cnx.close()
    
    def insertData(self, data, values):
        self.doThis(data, values)
    
    def updateData(self, data, values):
        self.doThis(data, values)
    
    def checkData(self, stn):
        cnx = mysql.connector.connect(user = self.USER,
                                      password = self.PWD,
                                      database = self.DB_NAME)
        cursor = cnx.cursor()
        cursor.execute(stn)
        result = cursor.fetchall()
        cnx.commit()
        cursor.close()
        cnx.close()
        # Get the value of the returned row, which will be 0 with a non-match
        if len(result):
            return True
        return False
    
    