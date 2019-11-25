module Lib
    (
    ) where

import Database.HDBC
import Database.HDBC.Sqlite3

import Network.HTTP.Simple
import qualified Data.ByteString as B

initialiseDB :: Connection -> IO ()
initialiseDB conn =
  do
    run conn "CREATE TABLE IF NOT EXISTS prices (\
             \stock VARCHAR(40) NOT NULL, \
             \date VARCHAR(40) NOT NULL, \
             \open FLOAT DEFAULT NULL, \
             \high FLOAT DEFAULT NULL, \
             \low FLOAT DEFAULT NULL, \
             \close FLOAT DEFAULT NULL, \
             \volume BIGINT(11) DEFAULT NULL\
             \)"
             []
    commit conn

data Price = Price {
   stock :: String,
   date :: String,
   open :: Double,
   high :: Double,
   low :: Double,
   close :: Double,
   volume :: Int
} deriving (Eq, Show)

testPrice = Price "test-stock" "test-date" 0.1 1.1 2.1 3.1 4

priceToSqlValues :: Price -> [SqlValue]
priceToSqlValues (Price stock date open high low close volume)
   = [toSql stock, toSql date, toSql open, toSql high, toSql low, toSql close, toSql volume]

prepareInsertPriceIOStmt :: Connection -> IO Statement
prepareInsertPriceIOStmt conn = prepare conn "INSERT INTO prices VALUES (?,?,?,?,?,?,?)"
