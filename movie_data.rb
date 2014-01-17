class rating
	attr_reader :user, :movie, :rate, :time 
	def initialize(user, movie, rate, time)
		@user = user
		@movie = movie
		@rate = rate
		@time = time
	end
end
class data
	attr_accessor :mov_pop_ar_hs, :user_ratings
	def initialize
		@mov_pop_ar_hs = []
		@user_ratings = []
	end

	#file must end at last rating
	def load_data
		data_array = IO.readlines('u.data')
		ratings_array=[]
		#ya this is gonna be an array of hashes
		#with array index as movie id and hash with kew of rank and value of count 
		movie_pop_array_hash=[]
		user_ratings_arr = []
		counter=0
		data_array.each do |line|
			temp = line.split("\t")
		####### tTHIS CREATES MOVIE POPULARITY TABLES
			#temp[1] is movie id [temp[2]] gets the hash value at the movies rating
			temp_ar1= movie_pop_array_hash[temp[1]]
			if temp_ar1.nil?
					movie_pop_array_hash[temp[1]]={}
			end
			num = movie_pop_array_hash[temp[1]][temp[2]]
			#check if the hash has a spot for the rating and update
			if num.nil?
				movie_pop_array_hash[temp[1]][temp[2]]=1
			else
				num++
				movie_pop_array_hash[temp[1]][temp[2]]=num
			end
			####### THIS CREATES USER RATING TABLES
			if user_ratings[temp[0]].nil? 
				user_ratings[temp[0]] = {temp[1] =>temp[2]}
			else
				user_ratings[temp[0]][temp[1]] = temp[2]
			end
		end
		mov_pop_ar_hs = movie_pop_array_hash
		user_ratings = user_ratings_arr	

		#if i wanted to make the ratings object though without filters the arrays seem to be more efficient
		=begin
		data_array.each do |line|
			temp = line.split("\t")
			ratings_array[counter]=rating.new(temp[0], temp[1], temp[2], temp[3])
			counter +=1
		end
		return ratings_array
		=end	

		return d
	end

	def popularity(movie_id)
		if mov_pop_ar_hs.nil?
			puts "#{movie_id} is an invalid movie"
			return 0
		else
			temp_hash = mov_pop_ar_hs[movie_id]
			sum = 0
			count = 0
			#ratings are integers so I can multiply them despite being keys
			temp_hash.each do |rating, num|
				#i am using the average to give the popularity of the movie
				#preserves ratings with respect to their frequency, simple, standard number out of 5 used by many other sites
				#lacks some finesse with the proportion of times viewed compaired to other movies, but works fine
				sum += rating*num
				count += num
			end
			return sum/count
		end

	end

	def popularity_list
		if mov_pop_ar_hs.nil?
			puts "data has not been loaded"
			return[]
		else
			movie_avg_pop=[]
			count = 1
			while count <= mov_pop_ar_hs.length
				movie_avg_pop[count]=popularity(count)
			end
			movie_avg_pop.sort! {|a,b| b<=> a}
			return movie_avg_pop
		end

	end
end

