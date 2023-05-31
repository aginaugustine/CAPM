
const mysrvdemo =  function(srv){
    srv.on('displaymsg',(req,res) => {
            return "hello " + req.data.msg;
    });
}
module.exports = mysrvdemo;