`timescale 1ns / 1ps

module Full_Subtractor(
    In_A, In_B, Borrow_in, Difference, Borrow_out
    );
    input In_A, In_B, Borrow_in;
    output Difference, Borrow_out;
    
    // implement full subtractor circuit, your code starts from here.
    // use half subtractor in this module, fulfill I/O ports connection.
    
	wire D1, B1, B2;
	Half_Subtractor HSUB1( In_A, In_B, D1, B1);
	Half_Subtractor HSUB2( D1, Borrow_in, Difference, B2);

//    Half_Subtractor HSUB (
//       .In_A(In_A), 
//       .In_B(In_A), 
//       .Difference(D1), 
//       .Borrow_out(B1)
//   );
   
//   Half_Subtractor HSUB2 (
//       .In_A(D1), 
//       .In_B(Borrow_in), 
//       .Difference(Difference), 
//       .Borrow_out(B2)
//   );
    or( Borrow_out, B1, B2);

endmodule
