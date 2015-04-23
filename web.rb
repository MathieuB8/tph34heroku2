require "bundler/setup"
require 'rubygems'
require 'sinatra'
require 'haml'

class Article
	attr_accessor :title,:body
	@nbrarticles = Dir["public/articles/*"].length/2

	def self.remplir_article i
		nomfichier = "public/articles/#{i}.txt"	
		article = Article.new
		article.title = File.open(nomfichier,"r").first
		corps = File.readlines(nomfichier)
		corps = corps[1..-1]
		corps = corps.join
		corps = corps[0..100]
		article.body = corps	
		article
	end

	def self.load i
		remplir_article(i)
	end

	def self.load_n_articles i
		articles_array = []
		for n in (1..i)
			articles_array << remplir_article(n)
		end
		return articles_array
	end	

	def self.load_weird_articles i
		articles_array = []

		if i > 2
			for n in (7..@nbrarticles)
				articles_array << remplir_article(n)
			end
		elsif i < 1
			for n in (1..3)
				articles_array << remplir_article(n)
			end		
		else
			for n in ( 1+3*(i-1) )..( 1+3*(i-1)+2 )
				articles_array << remplir_article(n)
			end
		end
		return articles_array
	end	

	def self.load_all
		articles_array = []
		for n in (1..@nbrarticles)
			articles_array << remplir_article(n)
		end
		return articles_array
	end	
end

#Code qui marche dans un programme ruby classique 
#articles = Article.load_all
#articles.each do |article|
#    puts article.body
#end

get '/' do
  @testz = "osef"
  @nbr_art = Dir["public/articles/*"].length/2
  if params['yolo']
	if params['yolo'].to_i > 8
  		@articles = Article.load_all
	else
		@articles = Article.load_n_articles(params['yolo'].to_i)
	end
  else
	  if params['page']
		@pages = params['page'].to_i
		if params['page'].to_i > 3
	  		@articles = Article.load_weird_articles(3)
		else
			@articles = Article.load_weird_articles(params['page'].to_i)
		end
	  else
		@pages = 1
	  	@articles = Article.load_all
	  end	  
  end	  

		
  haml :index
end

get '/:number' do
  @article = Article.load( params[:number] )
  @nbr_art = Dir["public/articles/*"].length/2
  haml :show
end

