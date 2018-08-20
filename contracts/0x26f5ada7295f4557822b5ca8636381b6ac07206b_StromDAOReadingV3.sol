contract StromDAOReadingV3  {
    
   mapping(address=>uint256) public readings;
   event pinged(address link,uint256 time,uint256 total,uint256 delta);
   
   function pingDelta(uint256 _delta) {
       readings[msg.sender]+=_delta;
       pinged(msg.sender,now,readings[msg.sender],_delta);
   }
   
   function pingReading(uint256 _reading) {
       pinged(msg.sender,now,_reading,_reading-readings[msg.sender]);
       readings[msg.sender]=_reading;
   }
}