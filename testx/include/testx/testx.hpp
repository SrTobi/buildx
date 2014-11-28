#pragma once
#ifdef TESTX_TEST
#ifndef TESTX_TESTX_HPP
#define TESTX_TESTX_HPP



#include <boost/test/unit_test.hpp>
#include <boost/make_shared.hpp>
#include <boost/utility.hpp>
#include <list>

#define TESTX_PARAM_TEST_CASE(_name, ...)	\
			void _name (__VA_ARGS__)

#define TESTX_AUTO_TEST_CASE(_name) \
			BOOST_AUTO_TEST_CASE(_name)

#define TESTX_PARAM_TEST(_func, ...)	\
			TESTX_PARAM_TEST_NAMED(_func, BOOST_JOIN(_func, BOOST_JOIN(_in_, __LINE__)), __VA_ARGS__)
#define TESTX_PARAM_TEST_NAMED(_func, _name, ...)	\
			BOOST_AUTO_TEST_CASE(_name)	{ _func(__VA_ARGS__); }

#define TESTX_START_FIXTURE_TEST(_test, ...)	\
			TESTX_START_FIXTURE_TEST_NAMED(BOOST_JOIN(_test, BOOST_JOIN(_in_, __LINE__)), _test, __VA_ARGS__)
#define TESTX_START_FIXTURE_TEST_NAMED(_name, _fixture, ...)								\
			struct BOOST_JOIN(_name, _help_fixture)										\
			{																			\
				typedef _fixture fixture;												\
				BOOST_JOIN(_name, _help_fixture)()										\
				{																		\
					m_fix = new fixture(__VA_ARGS__);									\
				}																		\
																						\
				~BOOST_JOIN(_name, _help_fixture)()										\
				{																		\
					delete m_fix;														\
				}																		\
																						\
				fixture* m_fix;															\
			};																			\
			BOOST_FIXTURE_TEST_SUITE(_name, BOOST_JOIN(_name, _help_fixture))			

#define TESTX_END_FIXTURE_TEST()		\
			BOOST_AUTO_TEST_SUITE_END()

#define TESTX_FIXTURE_TEST(_func, ...)	\
			TESTX_FIXTURE_TEST_NAMED(_func, BOOST_JOIN(_func, BOOST_JOIN(_in_, __LINE__)), __VA_ARGS__);
#define TESTX_FIXTURE_TEST_NAMED(_func, _name, ...)	\
			BOOST_AUTO_TEST_CASE(_name) { m_fix->_func(__VA_ARGS__); }

			
namespace testx {

	template<typename Events>
	class MockObserver
	{
	public:
		struct Inserter
		{
			Inserter(boost::shared_ptr<std::list<Events> > events)
				: events(events)
			{
			}

			Inserter& operator << (const Events& v)
			{
				events->push_back(v);
				return *this;
			}

		private:
			boost::shared_ptr<std::list<Events> > events;
		};

		MockObserver()
		{
			events = boost::make_shared<std::list<Events> >();
		}

		~MockObserver()
		{
			if(events.unique())
			{
				BOOST_CHECK_EQUAL(events->size(), 0);
			}
		}

		MockObserver(const MockObserver& other)
		{
			events = other.events;
		}

		void expect(const Events& v)
		{
			BOOST_REQUIRE(events->size());
			BOOST_CHECK_EQUAL(v, events->front());
			events->pop_front();
		}

		Inserter set()
		{
			return Inserter(events);
		}
		

	private:

		boost::shared_ptr<std::list<Events> > events;
	};

}

#endif
#endif