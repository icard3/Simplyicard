using Microsoft.EntityFrameworkCore;
using Bookstore.Api.DTOs;

namespace Bookstore.Api.Extensions;

/// <summary>
/// Extension methods for pagination
/// </summary>
public static class QueryableExtensions
{
    /// <summary>
    /// Applies pagination to a queryable
    /// </summary>
    /// <typeparam name="T">Type of entity</typeparam>
    /// <param name="query">Queryable to paginate</param>
    /// <param name="filter">Pagination filter</param>
    /// <returns>Paginated result</returns>
    public static async Task<PagedResult<T>> ToPagedResultAsync<T>(
        this IQueryable<T> query, 
        PaginationFilter filter) where T : class
    {
        var totalCount = await query.CountAsync();
        var skip = (filter.PageNumber - 1) * filter.PageSize;
        
        var data = await query
            .Skip(skip)
            .Take(filter.PageSize)
            .ToListAsync();
            
        return new PagedResult<T>
        {
            Data = data,
            PageNumber = filter.PageNumber,
            PageSize = filter.PageSize,
            TotalRecords = totalCount,
            TotalPages = (int)Math.Ceiling(totalCount / (double)filter.PageSize)
        };
    }
}