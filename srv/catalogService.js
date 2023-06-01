const catalogServiceHandler = cds.service.impl( async function(){
    
    const {EmployeeSet} = this.entities;
    this.before('UPDATE',EmployeeSet,(req,res) => {
      
        if(parseFloat(req.data.salaryAmount) >= 1000000) {
            //the reason for setting request is,we set request as bad before the req reaches the capm framework.
            //so once capm receive bad request,it sends the response with error message.
            req.error(500,"salary above the limits");
          // res.status(404);
        }
    });
});

module.exports = catalogServiceHandler;