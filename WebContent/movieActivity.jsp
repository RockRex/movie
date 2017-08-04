<%@ page contentType="text/html;charset=windows-1252"%>
<%@ page import="java.util.*" %>
<%@ page import="oracle.demo.oow.bd.to.ActivityTO" %>
<%@ page import="oracle.demo.oow.bd.to.MovieTO" %>
<%@ page import="oracle.demo.oow.bd.dao.hbase.ActivityDao" %>
<%@ page import="oracle.demo.oow.bd.dao.hbase.CustomerRatingDao" %>
<%@ page import="oracle.demo.oow.bd.dao.hbase.MovieDao" %>
<%@ page import="oracle.demo.oow.bd.pojo.ActivityType" %>
<%@ page import="oracle.demo.oow.bd.pojo.RatingType" %>
<%@ page import="java.util.Date" %>
<%
String movieId = request.getParameter("movieId");
String type = request.getParameter("type");

int movie = 0;
int userId = 0;
try {
   movie = Integer.parseInt(movieId);
   userId = (Integer)request.getSession().getAttribute("userId");
} catch (Exception e){
  movieId = "";
}
if (!movieId.equalsIgnoreCase("") && !type.equalsIgnoreCase("")){
    ActivityTO activityTO = new ActivityTO();
    
    if (type.equalsIgnoreCase("pause")){
        activityTO.setActivity(ActivityType.PAUSED_MOVIE);
        double time = Double.parseDouble(request.getParameter("time"));
        activityTO.setPosition(Math.round((float) time));
    }
    
    if (type.equalsIgnoreCase("play")){
        activityTO.setActivity(ActivityType.STARTED_MOVIE);
    }
    
    if (type.equalsIgnoreCase("purchase")){
        activityTO.setActivity(ActivityType.PURCHASED_MOVIE);
        MovieDao movieDao = new MovieDao();
        MovieTO movieTO = movieDao.getMovieById(Integer.valueOf(movieId));
        activityTO.setPrice(movieTO.getPrice());
        CustomerRatingDao rating = new CustomerRatingDao();
        rating.insertCustomerRating(userId, movie, 3);
    }
    
    if (type.equalsIgnoreCase("finish")){
        activityTO.setActivity(ActivityType.COMPLETED_MOVIE);
    }
    
    if (type.equalsIgnoreCase("rate")){
        String rate = request.getParameter("rate");
        int rateN = Integer.parseInt(rate);
        switch (rateN) {
          case 1:activityTO.setRating(RatingType.ONE);
              break;
          case 2:activityTO.setRating(RatingType.TWO);
              break;
          case 3:activityTO.setRating(RatingType.THREE);
              break;
          case 4:activityTO.setRating(RatingType.FOUR);
              break;
          case 5:activityTO.setRating(RatingType.FIVE);
              break;
          default:activityTO.setRating(RatingType.NO_RATING);
              break;
        }
        activityTO.setActivity(ActivityType.RATE_MOVIE);
        CustomerRatingDao rating = new CustomerRatingDao();
        rating.insertCustomerRating(userId, movie, rateN);
    }
    
    activityTO.setMovieId(movie);
    activityTO.setCustId(userId);
    ActivityDao aDAO = new ActivityDao();
    aDAO.insertCustomerActivity(activityTO);
}
%>